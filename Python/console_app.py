"""Console application for the Dynamic Fields & Records System.

Provides a simple, user-friendly menu to run the quick-start scripts,
examples, and inspect the `saves/` directory. Designed to be safe on
Windows and cross-platform.

Usage: `python console_app.py`
"""
from __future__ import annotations

import importlib
import importlib.util
import json
from datetime import datetime
from typing import Any
import sys
import subprocess
from pathlib import Path
from typing import Optional


ROOT = Path(__file__).resolve().parent
SAVES = ROOT / "saves"
SRC = ROOT / "src"

# Ensure `src/` is on sys.path so modules like `schema`, `record_structures`
# and `field_structures` import correctly when using `importlib.import_module`.
import sys
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))
    # Also make project root available for imports of top-level scripts
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

# Auto-move schemas/configs from `saves/` into `data/` on startup (non-destructive for metadata)
def _auto_reorganize():
    data_root = ROOT / "data"
    data_root.mkdir(exist_ok=True)
    moved = 0
    # Move schemas
    s_src = SAVES / "schemas"
    if s_src.exists():
        dst = data_root / "schemas"
        dst.mkdir(parents=True, exist_ok=True)
        for f in s_src.glob("*.json"):
            try:
                f.replace(dst / f.name)
                moved += 1
            except Exception:
                pass
        # remove schemas folder if empty
        try:
            if not any(s_src.iterdir()):
                s_src.rmdir()
        except Exception:
            pass

    # Move configs
    c_src = SAVES / "configs"
    if c_src.exists():
        dst = data_root / "configs"
        dst.mkdir(parents=True, exist_ok=True)
        for f in c_src.glob("*.json"):
            try:
                f.replace(dst / f.name)
                moved += 1
            except Exception:
                pass
        try:
            if not any(c_src.iterdir()):
                c_src.rmdir()
        except Exception:
            pass

    if moved:
        print(f"Auto-organized {moved} schema/config files into data/")


_auto_reorganize()


def run_subprocess(script: str, args: Optional[list[str]] = None) -> int:
    cmd = [sys.executable, str(ROOT / script)]
    if args:
        cmd += args
    print(f"\nRunning: {' '.join(cmd)}\n")
    try:
        completed = subprocess.run(cmd, check=False)
        return completed.returncode
    except Exception as e:
        print(f"Error running script: {e}")
        return 1


def run_module_function(module_name: str, func_name: Optional[str] = None) -> int:
    try:
        # Ensure project root is on sys.path
        if str(ROOT) not in sys.path:
            sys.path.insert(0, str(ROOT))
        module = importlib.import_module(module_name)
    except Exception as e:
        # Try to import by file path as a fallback (check project root and src/)
        def import_from_path(path: Path):
            try:
                spec = importlib.util.spec_from_file_location(module_name, str(path))
                if spec and spec.loader:
                    mod = importlib.util.module_from_spec(spec)
                    sys.modules[module_name] = mod
                    # Ensure src/ is on sys.path for relative imports inside module
                    src_path = str(ROOT / "src")
                    added = False
                    if src_path not in sys.path:
                        sys.path.insert(0, src_path)
                        added = True
                    try:
                        spec.loader.exec_module(mod)
                    finally:
                        if added:
                            try:
                                sys.path.remove(src_path)
                            except Exception:
                                pass
                    return mod
            except Exception:
                return None

        candidate_paths = [ROOT / f"{module_name}.py", ROOT / "src" / f"{module_name}.py"]
        module = None
        for p in candidate_paths:
            if p.exists():
                module = import_from_path(p)
                if module:
                    break

        if not module:
            print(f"Failed to import module '{module_name}': {e}")
            return 1

    try:
        if func_name:
            func = getattr(module, func_name, None)
            if not func:
                print(f"Module '{module_name}' has no function '{func_name}'.")
                return 1
            func()
            return 0
        # Prefer a `main()` function if present
        main = getattr(module, "main", None)
        if callable(main):
            main()
            return 0
        # Fallback: run as subprocess
        return run_subprocess(module.__file__)
    except Exception as e:
        print(f"Error while running '{module_name}.{func_name or 'main'}': {e}")
        return 1


def list_saves() -> None:
    if not SAVES.exists():
        print("No 'saves' directory found — nothing to list.")
        return

    for root, dirs, files in sorted(__import__("os").walk(SAVES)):
        rel = Path(root).relative_to(ROOT)
        print(f"\n{rel}:")
        for f in files:
            p = Path(root) / f
            try:
                size = p.stat().st_size
            except Exception:
                size = 0
            print(f"  - {f}    {size} bytes")


def _metadata_path_for_dat(file_path: Path) -> Path:
    return file_path.parent / f"{file_path.stem}_metadata.json"


def _load_metadata_for_dat(file_path: Path) -> dict:
    mpath = _metadata_path_for_dat(file_path)
    if not mpath.exists():
        raise FileNotFoundError(f"Metadata file not found: {mpath}")
    with mpath.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def detect_structure_auto(file_path: Path):
    """Attempt to detect record structure using metadata or file contents heuristics."""
    # 1) Use metadata if present
    try:
        meta = _load_metadata_for_dat(file_path)
        struct_meta = meta.get("structure_metadata") or meta.get("schema") or meta
        return _build_structure_from_metadata(struct_meta)
    except Exception:
        pass

    # 2) If index file present, assume indexed
    idx_path = file_path.parent / f"{file_path.stem}_index.json"
    if idx_path.exists():
        # try to find matching schema under data/schemas or saves/schemas
        schema = None
        data_schema_folder = ROOT / "data" / "schemas"
        save_schema_folder = SAVES / "schemas"
        for folder in (data_schema_folder, save_schema_folder):
            if folder.exists():
                for f in folder.glob("*.json"):
                    try:
                        jd = json.load(f.open("r", encoding="utf-8"))
                        if jd.get("schema_name") and jd.get("schema_name") in file_path.name:
                            schema = jd
                            break
                    except Exception:
                        continue
            if schema:
                break
        if schema:
            try:
                sd = importlib.import_module("schema")
            except Exception:
                sd = importlib.import_module("src.schema")
            fs = sd.FieldSchema.from_dict(schema)
            try:
                rs_mod = importlib.import_module("record_structures")
            except Exception:
                rs_mod = importlib.import_module("src.record_structures")
            return rs_mod.IndexedRecord(file_path.stem, fs)

    # 3) Heuristic: read sample bytes
    with file_path.open("rb") as fh:
        sample = fh.read(2048)
    text = sample.decode("utf-8", errors="replace")
    # If it contains '=' or '&' or ':' and '|' it might be key_value or delimiter
    if "=" in text and ("&" in text or ";" in text):
        try:
            schema_mod = importlib.import_module("schema")
        except Exception:
            schema_mod = importlib.import_module("src.schema")
        # fallback to a basic key_value schema with single field
        f = schema_mod.FieldSchema("autodetected_kv")
        from field_structures import KeyValueField

        f.add_field(KeyValueField("kv", "=", "&"))
        try:
            rs_mod = importlib.import_module("record_structures")
        except Exception:
            rs_mod = importlib.import_module("src.record_structures")
        return rs_mod.DelimiterRecord(file_path.stem, f)

    # If contains '|' delimiter and newlines, assume DelimiterRecord
    if "|" in text or "\n" in text:
        try:
            schema_mod = importlib.import_module("schema")
        except Exception:
            schema_mod = importlib.import_module("src.schema")
        f = schema_mod.FieldSchema("autodetected_delim")
        from field_structures import DelimiterField

        f.add_field(DelimiterField("cols", "|"))
        try:
            rs_mod = importlib.import_module("record_structures")
        except Exception:
            rs_mod = importlib.import_module("src.record_structures")
        return rs_mod.DelimiterRecord(file_path.stem, f)

    # Otherwise assume fixed-size binary record (wrap in FixedSizeRecord with single bytes field)
    try:
        schema_mod = importlib.import_module("schema")
    except Exception:
        schema_mod = importlib.import_module("src.schema")
    f = schema_mod.FieldSchema("autodetected_fixed")
    from field_structures import FixedSizeField

    # Guess a size by looking for repeated content: fallback to entire file as single record
    filesize = file_path.stat().st_size
    guessed = filesize
    try:
        fs_field = FixedSizeField("blob", guessed, "bytes")
        f.add_field(fs_field)
        rs_mod = importlib.import_module("record_structures")
        return rs_mod.FixedSizeRecord(file_path.stem, f)
    except Exception:
        # last resort delimiter
        rs_mod = importlib.import_module("record_structures")
        return rs_mod.DelimiterRecord(file_path.stem, f)


def _build_structure_from_metadata(metadata: dict):
    """Build a RecordStructure instance from metadata dict."""
    try:
        rs_mod = importlib.import_module("src.record_structures")
        schema_mod = importlib.import_module("src.schema")
    except Exception:
        rs_mod = importlib.import_module("record_structures")
        schema_mod = importlib.import_module("schema")

    schema_dict = metadata.get("schema") or metadata.get("structure_metadata", {}).get("schema")
    if not schema_dict:
        raise ValueError("No schema found in metadata")

    field_schema = schema_mod.FieldSchema.from_dict(schema_dict)
    rtype = metadata.get("type") or metadata.get("structure_metadata", {}).get("type")

    if rtype == "fixed_size":
        return rs_mod.FixedSizeRecord(metadata.get("name") or metadata.get("structure_metadata", {}).get("name", "unnamed"), field_schema)
    elif rtype == "delimiter":
        return rs_mod.DelimiterRecord(metadata.get("name") or metadata.get("structure_metadata", {}).get("name", "unnamed"), field_schema)
    elif rtype == "pre_known_fields" or rtype == "pre_known":
        return rs_mod.PreKnownFieldsRecord(metadata.get("name") or metadata.get("structure_metadata", {}).get("name", "unnamed"), field_schema)
    elif rtype == "indexed" or rtype == "index":
        return rs_mod.IndexedRecord(metadata.get("name") or metadata.get("structure_metadata", {}).get("name", "unnamed"), field_schema)
    else:
        # default to DelimiterRecord
        return rs_mod.DelimiterRecord(metadata.get("name") or metadata.get("structure_metadata", {}).get("name", "unnamed"), field_schema)


def _select_dat_file() -> Optional[Path]:
    """Prompt user to select a .dat file under `saves/`."""
    all_dat = list(Path(SAVES).rglob("*.dat"))
    if not all_dat:
        print("No .dat files found in `saves/`.")
        return None
    for i, p in enumerate(all_dat, 1):
        print(f"{i}) {p.relative_to(ROOT)}")
    choice = input("Select file number (or 'q' to cancel): ").strip()
    if choice.lower() == "q":
        return None
    try:
        idx = int(choice) - 1
        return all_dat[idx]
    except Exception:
        print("Invalid selection")
        return None


def read_records_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        # Try to detect structure using metadata or heuristics
        structure = detect_structure_auto(p)
        # Use DataStorage handler to read
        ds_mod = importlib.import_module("src.file_manager")
    except Exception as e:
        print(f"Failed to prepare structure: {e}")
        return

    handler = ds_mod.FileHandler(ds_mod.FileOrganizer(str(SAVES)))
    try:
        records = handler.read_records(structure, p)
    except Exception as e:
        print(f"Error reading records: {e}")
        return

    print(f"Read {len(records)} records:")
    for i, r in enumerate(records, 1):
        print(f" {i}. {r}")


def append_record_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        structure = detect_structure_auto(p)
        ds_mod = importlib.import_module("src.file_manager")
        storage = ds_mod.DataStorage(str(SAVES))
        storage.register_structure(structure)
    except Exception as e:
        print(f"Failed to prepare structure: {e}")
        return

    print("Enter record as JSON, e.g.: {\"id\": \"C0003\", \"name\": \"Charlie\"}")
    raw = input("Record JSON: ").strip()
    try:
        rec = json.loads(raw)
    except Exception as e:
        print(f"Invalid JSON: {e}")
        return

    try:
        storage.append_data(structure.name, rec, p)
        print("Record appended.")
    except Exception as e:
        print(f"Failed to append record: {e}")


def _overwrite_file_with_records(file_path: Path, structure, records: list[dict]) -> None:
    ds_mod = importlib.import_module("src.file_manager")
    organizer = ds_mod.FileOrganizer(str(SAVES))
    handler = ds_mod.FileHandler(organizer)
    handler.write_records(structure, records, file_path)


def update_record_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        structure = detect_structure_auto(p)
        ds_mod = importlib.import_module("src.file_manager")
        handler = ds_mod.FileHandler(ds_mod.FileOrganizer(str(SAVES)))
        records = handler.read_records(structure, p)
    except Exception as e:
        print(f"Failed to load records: {e}")
        return

    if not records:
        print("No records to update.")
        return
    for i, r in enumerate(records, 1):
        print(f"{i}) {r}")
    choice = input("Select record number to update (or 'q'): ").strip()
    if choice.lower() == "q":
        return
    try:
        idx = int(choice) - 1
        old = records[idx]
    except Exception:
        print("Invalid selection")
        return

    print("Current record:", old)
    print("Enter new record JSON (full replacement):")
    raw = input("New JSON: ").strip()
    try:
        newrec = json.loads(raw)
    except Exception as e:
        print(f"Invalid JSON: {e}")
        return

    records[idx] = newrec
    try:
        _overwrite_file_with_records(p, structure, records)
        print("Record updated and file rewritten.")
    except Exception as e:
        print(f"Failed to write file: {e}")


def delete_record_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        structure = detect_structure_auto(p)
        ds_mod = importlib.import_module("src.file_manager")
        handler = ds_mod.FileHandler(ds_mod.FileOrganizer(str(SAVES)))
        records = handler.read_records(structure, p)
    except Exception as e:
        print(f"Failed to load records: {e}")
        return

    if not records:
        print("No records to delete.")
        return
    for i, r in enumerate(records, 1):
        print(f"{i}) {r}")
    choice = input("Select record number to delete (or 'q'): ").strip()
    if choice.lower() == "q":
        return
    try:
        idx = int(choice) - 1
        records.pop(idx)
    except Exception:
        print("Invalid selection")
        return

    try:
        _overwrite_file_with_records(p, structure, records)
        print("Record deleted and file rewritten.")
    except Exception as e:
        print(f"Failed to write file: {e}")


def delete_file_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    confirm = input(f"Delete file {p.relative_to(ROOT)}? (y/N): ").strip().lower()
    if confirm != "y":
        print("Cancelled")
        return
    try:
        # remove data, metadata, index if present
        mpath = _metadata_path_for_dat(p)
        idxpath = p.parent / f"{p.stem}_index.json"
        p.unlink()
        if mpath.exists():
            mpath.unlink()
        if idxpath.exists():
            idxpath.unlink()
        print("Deleted file and related metadata/index.")
    except Exception as e:
        print(f"Failed to delete: {e}")


def delete_all_saves_interactive() -> None:
    """Delete all files and folders under `saves/` after confirmation."""
    confirm = input("This will DELETE all files under 'saves/' (y/N): ").strip().lower()
    if confirm != "y":
        print("Cancelled")
        return
    import shutil
    try:
        for child in SAVES.iterdir():
            if child.is_dir():
                shutil.rmtree(child)
            else:
                child.unlink()
        print("All saves removed.")
    except Exception as e:
        print(f"Failed to clear saves: {e}")


def _get_value_from_record(record: dict, field_path: str):
    """Support dotted field paths to extract nested values from a record."""
    parts = field_path.split(".") if field_path else []
    cur = record
    for p in parts:
        if isinstance(cur, dict) and p in cur:
            cur = cur[p]
        else:
            return None
    return cur


def search_records_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        structure = detect_structure_auto(p)
        ds_mod = importlib.import_module("src.file_manager")
        handler = ds_mod.FileHandler(ds_mod.FileOrganizer(str(SAVES)))
    except Exception as e:
        print(f"Failed to prepare search: {e}")
        return

    field = input("Field name to search (use '.' for nested, e.g. 'settings.volume'): ").strip()
    if not field:
        print("Field name required")
        return
    value = input("Value to match: ").strip()
    mode = input("Match mode: (1) equals (exact)  (2) contains (substring) [default 1]: ").strip() or "1"

    def predicate(rec):
        v = _get_value_from_record(rec, field)
        if v is None:
            return False
        try:
            sv = str(v)
        except Exception:
            return False
        if mode == "2":
            return value in sv
        return sv == value

    # Prefer indexed search if index file exists and we can create an IndexedRecord
    idx_path = p.parent / f"{p.stem}_index.json"
    try:
        # If structure is already IndexedRecord, use handler.indexed_search
        rs_mod = importlib.import_module("src.record_structures")
    except Exception:
        rs_mod = importlib.import_module("record_structures")

    use_index = False
    try:
        if isinstance(structure, rs_mod.IndexedRecord):
            use_index = True
        elif idx_path.exists():
            # build an IndexedRecord from the detected structure's schema
            if hasattr(structure, "schema"):
                structure = rs_mod.IndexedRecord(structure.name, structure.schema)
                use_index = True
    except Exception:
        use_index = False

    try:
        if use_index:
            result = handler.indexed_search(structure, p, predicate)
            method = "indexed"
        else:
            result = handler.sequential_search(structure, p, predicate)
            method = "sequential"
    except Exception as e:
        print(f"Search failed: {e}")
        return

    matches = result.get("matches", [])
    t = result.get("time_seconds", 0.0)
    scanned = result.get("scanned", 0)
    print(f"Search method: {method}")
    print(f"Scanned: {scanned} records, Matches: {len(matches)}, Time: {t:.6f} seconds")
    for i, m in enumerate(matches, 1):
        print(f" {i}) {m}")


def read_by_rrn_interactive() -> None:
    p = _select_dat_file()
    if not p:
        return
    try:
        structure = detect_structure_auto(p)
        ds_mod = importlib.import_module("src.file_manager")
        handler = ds_mod.FileHandler(ds_mod.FileOrganizer(str(SAVES)))
    except Exception as e:
        print(f"Failed to prepare RRN read: {e}")
        return

    rrn_raw = input("Enter RRN (starting at 0): ").strip()
    try:
        rrn = int(rrn_raw)
    except Exception:
        print("Invalid RRN")
        return

    try:
        rec = handler.read_record_by_rrn(structure, p, rrn)
        print(f"Record at RRN {rrn}: {rec}")
    except Exception as e:
        print(f"RRN read failed: {e}")


def reorganize_storage_interactive() -> None:
    """Move schema/config/metadata JSON files into a `data/` folder and leave `.dat` files under `saves/`."""
    data_root = ROOT / "data"
    data_root.mkdir(exist_ok=True)
    data_schemas = data_root / "schemas"
    data_configs = data_root / "configs"
    data_meta = data_root / "metadata"
    data_schemas.mkdir(parents=True, exist_ok=True)
    data_configs.mkdir(parents=True, exist_ok=True)
    data_meta.mkdir(parents=True, exist_ok=True)

    moved = 0
    # Walk saves and move JSON files
    for p in list(SAVES.rglob("*.json")):
        try:
            name = p.name.lower()
            if "schema" in name or p.parent.name == "schemas":
                target = data_schemas / p.name
            elif "config" in name or p.parent.name == "configs":
                target = data_configs / p.name
            elif name.endswith("_metadata.json") or name.endswith("_index.json"):
                target = data_meta / p.name
            else:
                # default to data_meta
                target = data_meta / p.name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.replace(target)
            moved += 1
        except Exception as e:
            print(f"Failed to move {p}: {e}")

    # Remove empty dirs under saves
    for d in sorted([p for p in SAVES.rglob("*") if p.is_dir()], reverse=True):
        try:
            if not any(d.iterdir()):
                d.rmdir()
        except Exception:
            pass

    print(f"Reorganization complete. Moved {moved} JSON files to 'data/'.")


def list_schema_files() -> None:
    folder = SAVES / "schemas"
    if not folder.exists():
        print("No schemas folder found.")
        return
    for f in sorted(folder.glob("*.json")):
        print(f"- {f.name}")


def create_schema_interactive() -> None:
    folder = SAVES / "schemas"
    folder.mkdir(parents=True, exist_ok=True)
    name = input("Schema name (identifier): ").strip()
    if not name:
        print("Name required")
        return
    schema = {"schema_name": name, "fields": []}
    print("Enter fields one by one. To finish, enter a single '.' as the field name.")
    while True:
        fname = input(" Field name (or '.' to finish): ").strip()
        if fname == ".":
            break
        if not fname:
            print("Field name required or '.' to finish")
            continue
        ftype = input(" Field type (fixed_size|delimiter|key_value|length_indicator): ").strip()
        cfg = {"name": fname, "type": ftype}
        if ftype == "fixed_size":
            cfg["size"] = int(input("  size (bytes): ").strip())
        if ftype == "delimiter":
            cfg["delimiter"] = input("  delimiter (single char): ").strip() or "|"
        if ftype == "key_value":
            cfg["pair_delimiter"] = input("  pair_delimiter (default '='): ").strip() or "="
            cfg["field_delimiter"] = input("  field_delimiter (default '&'): ").strip() or "&"
        if ftype == "length_indicator":
            cfg["length_size"] = int(input("  length_size (bytes for length): ").strip() or 4)
        schema["fields"].append(cfg)

    out = folder / f"{name}.json"
    with out.open("w", encoding="utf-8") as fh:
        json.dump(schema, fh, indent=2)
    print(f"Saved schema to {out.relative_to(ROOT)}")


def schema_management_menu() -> None:
    while True:
        print("\nSchema Management:\n 1) List schemas\n 2) Create schema\n 3) Delete schema\n 0) Back")
        c = input("Choice: ").strip()
        if c == "1":
            list_schema_files()
        elif c == "2":
            create_schema_interactive()
        elif c == "3":
            folder = SAVES / "schemas"
            list_schema_files()
            name = input("Schema filename to delete (without .json): ").strip()
            if not name:
                continue
            f = folder / f"{name}.json"
            if f.exists():
                f.unlink()
                print("Deleted")
            else:
                print("Not found")
        elif c == "0":
            break
        else:
            print("Invalid choice")


def edit_schema_interactive() -> None:
    folder = SAVES / "schemas"
    if not folder.exists():
        print("No schemas to edit.")
        return
    schemas = sorted(folder.glob("*.json"))
    for i, f in enumerate(schemas, 1):
        print(f"{i}) {f.name}")
    choice = input("Select schema to edit (or 'q'): ").strip()
    if choice.lower() == "q":
        return
    try:
        idx = int(choice) - 1
        sf = schemas[idx]
    except Exception:
        print("Invalid selection")
        return

    with sf.open("r", encoding="utf-8") as fh:
        schema = json.load(fh)

    while True:
        print(f"\nEditing {sf.name}")
        fields = schema.get("fields", [])
        for i, fld in enumerate(fields, 1):
            print(f"{i}) {fld}")
        print("a) Add field\nr) Remove field\ns) Save and exit\nc) Cancel")
        cmd = input("Choice: ").strip().lower()
        if cmd == "a":
            print("Enter '.' as field name to cancel adding")
            fname = input(" Field name: ").strip()
            if fname == ".":
                continue
            ftype = input(" Field type (fixed_size|delimiter|key_value|length_indicator): ").strip()
            cfg = {"name": fname, "type": ftype}
            if ftype == "fixed_size":
                cfg["size"] = int(input("  size (bytes): ").strip())
            if ftype == "delimiter":
                cfg["delimiter"] = input("  delimiter (single char): ").strip() or "|"
            if ftype == "key_value":
                cfg["pair_delimiter"] = input("  pair_delimiter (default '='): ").strip() or "="
                cfg["field_delimiter"] = input("  field_delimiter (default '&'): ").strip() or "&"
            if ftype == "length_indicator":
                cfg["length_size"] = int(input("  length_size (bytes for length): ").strip() or 4)
            fields.append(cfg)
        elif cmd == "r":
            n = input("Field number to remove: ").strip()
            try:
                ni = int(n) - 1
                fields.pop(ni)
            except Exception:
                print("Invalid number")
        elif cmd == "s":
            schema["fields"] = fields
            with sf.open("w", encoding="utf-8") as fh:
                json.dump(schema, fh, indent=2)
            print("Saved")
            return
        elif cmd == "c":
            print("Cancelled")
            return
        else:
            print("Unknown command")


def create_file_interactive() -> None:
    # Choose schema or create new
    folder = SAVES / "schemas"
    schema_choice = None
    if folder.exists():
        schemas = sorted(folder.glob("*.json"))
        if schemas:
            print("Available schemas:")
            for i, f in enumerate(schemas, 1):
                print(f"{i}) {f.name}")
            print("n) Create new schema")
            ch = input("Pick schema number or 'n': ").strip().lower()
            if ch == "n":
                create_schema_interactive()
                schemas = sorted(folder.glob("*.json"))
                if not schemas:
                    print("No schemas available")
                    return
                schema_choice = schemas[-1]
            else:
                try:
                    idx = int(ch) - 1
                    schema_choice = schemas[idx]
                except Exception:
                    print("Invalid selection")
                    return
    else:
        print("No schemas folder; create one now.")
        create_schema_interactive()
        folder.mkdir(parents=True, exist_ok=True)
        schemas = sorted(folder.glob("*.json"))
        if not schemas:
            print("No schemas available")
            return
        schema_choice = schemas[-1]

    # Load schema
    with schema_choice.open("r", encoding="utf-8") as fh:
        schema_dict = json.load(fh)

    # Build structure from schema
    try:
        schema_mod = importlib.import_module("src.schema")
    except Exception:
        schema_mod = importlib.import_module("schema")
    field_schema = schema_mod.FieldSchema.from_dict(schema_dict)

    print("Choose record structure type:")
    print("1) fixed_size 2) delimiter 3) pre_known_fields 4) indexed")
    rch = input("Choice: ").strip()
    try:
        rs_mod = importlib.import_module("src.record_structures")
    except Exception:
        rs_mod = importlib.import_module("record_structures")

    name = input("Record structure name (identifier): ").strip() or schema_dict.get("schema_name", "record")
    if rch == "1":
        structure = rs_mod.FixedSizeRecord(name, field_schema)
    elif rch == "2":
        structure = rs_mod.DelimiterRecord(name, field_schema)
    elif rch == "3":
        structure = rs_mod.PreKnownFieldsRecord(name, field_schema)
    else:
        structure = rs_mod.IndexedRecord(name, field_schema)

    file_name = input("File name (without extension): ").strip()
    if not file_name:
        print("Filename required")
        return
    by_date = input("Organize by date? (Y/n): ").strip().lower() != "n"

    print("Enter records as JSON objects, one per line. Blank line to finish.")
    print("(Enter '.' on a line alone to finish)")
    records = []
    while True:
        line = input().strip()
        if not line or line == ".":
            break
        try:
            obj = json.loads(line)
            records.append(obj)
        except Exception as e:
            print(f"Invalid JSON: {e}")

    if not records:
        print("No records entered; aborting.")
        return

    try:
        ds_mod = importlib.import_module("src.file_manager")
    except Exception:
        ds_mod = importlib.import_module("file_manager")

    storage = ds_mod.DataStorage(str(SAVES))
    storage.register_structure(structure)
    try:
        path = storage.save_data(structure.name, records, file_name, organize_by_date=by_date)
        print(f"Saved to: {path}")
    except Exception as e:
        print(f"Failed to save file: {e}")


def prompt_choice() -> str:
    menu = """
Dynamic Fields & Records — Console App

Select an option (enter number):
 1) Run all Quick Starts (quick_start.py)
 2) Run Quick Start 1
 3) Run Quick Start 2
 4) Run Quick Start 3
 5) Run Quick Start 4
 6) Run examples.py
 7) List files in `saves/`
 8) Read records from a saved file
 9) Append a record to a saved file
10) Update a record by index
11) Delete a record by index
12) Delete a saved file
13) Schema management (create/list/delete schemas)
 14) Edit an existing schema
 15) Create new data file from schema (interactive)       
 16) Run quick smoke test (quick_start + examples)
 17) Delete ALL saves (destructive)
18) Search records (sequential vs indexed, reports time)
19) Read record by RRN (fixed-length)
 0) Exit
"""
    print(menu)
    return input("Choice: ").strip()


def main() -> None:
    print("\n=== Dynamic Fields & Records — Console ===\n")
    while True:
        choice = prompt_choice()
        if choice == "1":
            rc = run_module_function("quick_start")
        elif choice == "2":
            rc = run_module_function("quick_start", "quick_start_1")
        elif choice == "3":
            rc = run_module_function("quick_start", "quick_start_2")
        elif choice == "4":
            rc = run_module_function("quick_start", "quick_start_3")
        elif choice == "5":
            rc = run_module_function("quick_start", "quick_start_4")
        elif choice == "6":
            rc = run_module_function("examples")
        elif choice == "7":
            list_saves()
            rc = 0
        elif choice == "8":
            read_records_interactive()
            rc = 0
        elif choice == "9":
            append_record_interactive()
            rc = 0
        elif choice == "10":
            update_record_interactive()
            rc = 0
        elif choice == "11":
            delete_record_interactive()
            rc = 0
        elif choice == "12":
            delete_file_interactive()
            rc = 0
        elif choice == "13":
            schema_management_menu()
            rc = 0
        elif choice == "14":
            edit_schema_interactive()
            rc = 0
        elif choice == "15":
            create_file_interactive()
            rc = 0
        elif choice == "17":
            delete_all_saves_interactive()
            rc = 0
        elif choice == "18":
            search_records_interactive()
            rc = 0
        elif choice == "19":
            read_by_rrn_interactive()
            rc = 0
        elif choice == "16":
            print("Running quick smoke test: quick_start then examples\n")
            rc1 = run_module_function("quick_start")
            rc2 = run_module_function("examples")
            rc = rc1 or rc2
        elif choice == "0":
            print("Exiting. Goodbye!")
            break
        else:
            print("Invalid choice — please enter a number from the menu.")
            rc = 0

        if rc != 0:
            print(f"\nOperation finished with exit code {rc}. Check output above for details.")


if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, EOFError):
        print("\nInterrupted — exiting.")
