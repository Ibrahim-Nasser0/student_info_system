"""
File Manager and Storage
Handles file serialization, deserialization, and organization
"""

import os
import json
from typing import List, Dict, Any, Optional
from pathlib import Path
from datetime import datetime
from schema import FieldSchema
from record_structures import RecordStructure, IndexedRecord
import time


class FileOrganizer:
    """Organizes and manages saved files"""

    def __init__(self, base_directory: str):
        """
        Initialize file organizer

        Args:
            base_directory: Base directory for saving files
        """
        self.base_directory = Path(base_directory)
        self.base_directory.mkdir(parents=True, exist_ok=True)

    def create_structure_directory(self, structure_name: str) -> Path:
        """Create directory for a specific structure"""
        structure_path = self.base_directory / structure_name
        structure_path.mkdir(parents=True, exist_ok=True)
        return structure_path

    def create_dated_directory(self, structure_name: str) -> Path:
        """Create dated subdirectory for a structure"""
        structure_path = self.create_structure_directory(structure_name)
        date_dir = structure_path / datetime.now().strftime("%Y-%m-%d")
        date_dir.mkdir(parents=True, exist_ok=True)
        return date_dir

    def save_metadata(self, file_path: Path, metadata: Dict[str, Any]) -> None:
        """Save metadata alongside data file"""
        metadata_path = file_path.parent / f"{file_path.stem}_metadata.json"
        with open(metadata_path, "w") as f:
            json.dump(metadata, f, indent=2)

    def load_metadata(self, file_path: Path) -> Dict[str, Any]:
        """Load metadata for a data file"""
        metadata_path = file_path.parent / f"{file_path.stem}_metadata.json"
        if metadata_path.exists():
            with open(metadata_path, "r") as f:
                return json.load(f)
        return {}

    def get_all_files(self, structure_name: str) -> List[Path]:
        """Get all data files for a structure"""
        structure_path = self.base_directory / structure_name
        if not structure_path.exists():
            return []
        return [f for f in structure_path.rglob("*.dat") if "_metadata" not in f.name]

    def get_files_by_date(self, structure_name: str, date: str) -> List[Path]:
        """Get files for a specific date (format: YYYY-MM-DD)"""
        date_path = self.base_directory / structure_name / date
        if not date_path.exists():
            return []
        return [f for f in date_path.glob("*.dat") if "_metadata" not in f.name]


class FileHandler:
    """Handles reading and writing of record files"""

    def __init__(self, organizer: FileOrganizer):
        """
        Initialize file handler

        Args:
            organizer: FileOrganizer instance
        """
        self.organizer = organizer

    def write_records(
        self,
        structure: RecordStructure,
        records: List[Dict[str, Any]],
        file_path: Path,
        create_index: bool = True,
    ) -> None:
        """
        Write records to file

        Args:
            structure: RecordStructure to use for encoding
            records: List of record dictionaries
            file_path: Path to save file
            create_index: Whether to create index file
        """
        file_path.parent.mkdir(parents=True, exist_ok=True)

        encoded_data = b""
        for record in records:
            encoded_data += structure.encode_record(record)

        with open(file_path, "wb") as f:
            f.write(encoded_data)

        # Save metadata
        metadata = {
            "record_count": len(records),
            "structure_name": structure.name,
            "structure_metadata": structure.get_metadata(),
            "created_at": datetime.now().isoformat(),
            "file_size": len(encoded_data),
        }
        self.organizer.save_metadata(file_path, metadata)

        # Create index if applicable
        if create_index and isinstance(structure, IndexedRecord):
            structure.build_index(encoded_data)
            self._write_index(structure, file_path)

    def read_records(self, structure: RecordStructure, file_path: Path) -> List[Dict[str, Any]]:
        """
        Read records from file

        Args:
            structure: RecordStructure to use for decoding
            file_path: Path to read file from

        Returns:
            List of decoded records
        """
        with open(file_path, "rb") as f:
            data = f.read()

        records = []
        offset = 0

        while offset < len(data):
            try:
                record, bytes_consumed = structure.decode_record(data[offset:])
                records.append(record)
                offset += bytes_consumed
            except ValueError:
                # End of valid data
                break

        return records

    def read_record_by_rrn(self, structure: RecordStructure, file_path: Path, rrn: int) -> Optional[Dict[str, Any]]:
        """Read a single fixed-length record by RRN (relative record number).

        Only valid for FixedSizeRecord (or structures with known record_size).
        """
        # Try to get record_size attribute
        record_size = getattr(structure, "record_size", None)
        if record_size is None:
            raise ValueError("Structure does not support RRN access (no record_size)")

        offset = rrn * record_size
        with open(file_path, "rb") as f:
            f.seek(0, 2)
            total = f.tell()
            if offset + record_size > total:
                raise IndexError("RRN out of range")
            f.seek(offset)
            data = f.read(record_size)

        record, _ = structure.decode_record(data)
        return record

    def sequential_search(self, structure: RecordStructure, file_path: Path, predicate) -> Dict[str, Any]:
        """Sequentially scan records and return matches plus timing info.

        predicate: function(record) -> bool
        Returns: {matches: [...], time_seconds: float, scanned: int}
        """
        start = time.perf_counter()
        matches = []
        scanned = 0
        with open(file_path, "rb") as f:
            data = f.read()

        offset = 0
        while offset < len(data):
            try:
                record, consumed = structure.decode_record(data[offset:])
            except Exception:
                break
            scanned += 1
            if predicate(record):
                matches.append(record)
            offset += consumed

        duration = time.perf_counter() - start
        return {"matches": matches, "time_seconds": duration, "scanned": scanned}

    def indexed_search(self, structure: IndexedRecord, file_path: Path, predicate) -> Dict[str, Any]:
        """Use index (if present) to retrieve records and test predicate; returns timing and matches.

        If index file exists, this will read index and access records via offsets.
        """
        start = time.perf_counter()
        with open(file_path, "rb") as f:
            data = f.read()

        # Build index from structure (will populate structure.index)
        structure.build_index(data)
        matches = []
        for idx_entry in structure.index:
            off, size = idx_entry
            rec_data = data[off: off + size]
            try:
                record, _ = structure.decode_record(rec_data)
            except Exception:
                continue
            if predicate(record):
                matches.append(record)

        duration = time.perf_counter() - start
        return {"matches": matches, "time_seconds": duration, "scanned": len(structure.index)}

    def append_record(self, structure: RecordStructure, record: Dict[str, Any], file_path: Path) -> None:
        """
        Append a single record to file

        Args:
            structure: RecordStructure to use
            record: Record dictionary to append
            file_path: Path to file
        """
        encoded_record = structure.encode_record(record)

        with open(file_path, "ab") as f:
            f.write(encoded_record)

        # Update metadata
        metadata = self.organizer.load_metadata(file_path)
        metadata["record_count"] = metadata.get("record_count", 0) + 1
        metadata["updated_at"] = datetime.now().isoformat()
        self.organizer.save_metadata(file_path, metadata)

    def _write_index(self, structure: IndexedRecord, file_path: Path) -> None:
        """Write index file"""
        index_path = file_path.parent / f"{file_path.stem}_index.json"
        index_data = {
            "record_count": structure.get_record_count(),
            "index": [(offset, size) for offset, size in structure.index],
        }
        with open(index_path, "w") as f:
            json.dump(index_data, f, indent=2)

    def read_index(self, file_path: Path) -> Optional[Dict[str, Any]]:
        """Read index file if it exists"""
        index_path = file_path.parent / f"{file_path.stem}_index.json"
        if index_path.exists():
            with open(index_path, "r") as f:
                return json.load(f)
        return None


class DataStorage:
    """High-level data storage interface"""

    def __init__(self, base_directory: str = "saves"):
        """
        Initialize data storage

        Args:
            base_directory: Base directory for storage
        """
        self.organizer = FileOrganizer(base_directory)
        self.handler = FileHandler(self.organizer)
        self.structures: Dict[str, RecordStructure] = {}

    def register_structure(self, structure: RecordStructure) -> None:
        """Register a record structure"""
        self.structures[structure.name] = structure

    def get_structure(self, name: str) -> Optional[RecordStructure]:
        """Get a registered structure by name"""
        return self.structures.get(name)

    def save_data(
        self,
        structure_name: str,
        records: List[Dict[str, Any]],
        file_name: str,
        organize_by_date: bool = True,
    ) -> Path:
        """
        Save data with a structure

        Args:
            structure_name: Name of registered structure
            records: Records to save
            file_name: Name of file (without extension)
            organize_by_date: Whether to organize in dated directories

        Returns:
            Path to saved file
        """
        structure = self.get_structure(structure_name)
        if structure is None:
            raise ValueError(f"Structure '{structure_name}' not registered")

        if organize_by_date:
            save_dir = self.organizer.create_dated_directory(structure_name)
        else:
            save_dir = self.organizer.create_structure_directory(structure_name)

        file_path = save_dir / f"{file_name}.dat"
        self.handler.write_records(structure, records, file_path)
        return file_path

    def load_data(self, structure_name: str, file_path: Path) -> List[Dict[str, Any]]:
        """
        Load data with a structure

        Args:
            structure_name: Name of registered structure
            file_path: Path to file

        Returns:
            Loaded records
        """
        structure = self.get_structure(structure_name)
        if structure is None:
            raise ValueError(f"Structure '{structure_name}' not registered")

        return self.handler.read_records(structure, file_path)

    def append_data(self, structure_name: str, record: Dict[str, Any], file_path: Path) -> None:
        """
        Append record to existing file

        Args:
            structure_name: Name of registered structure
            record: Record to append
            file_path: Path to file
        """
        structure = self.get_structure(structure_name)
        if structure is None:
            raise ValueError(f"Structure '{structure_name}' not registered")

        self.handler.append_record(structure, record, file_path)

    def list_structures(self) -> Dict[str, str]:
        """List all available structures"""
        return {name: structure.get_metadata() for name, structure in self.structures.items()}

    def list_saved_files(self, structure_name: str) -> List[Dict[str, Any]]:
        """List all saved files for a structure"""
        files = self.organizer.get_all_files(structure_name)
        result = []
        for file_path in files:
            metadata = self.organizer.load_metadata(file_path)
            result.append({
                "file": str(file_path),
                "size": file_path.stat().st_size,
                **metadata,
            })
        return result
