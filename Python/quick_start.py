"""
Quick Start Guide
Get up and running in minutes
"""

from pathlib import Path
import sys

# Add src to path
sys.path.insert(0, str(Path(__file__).parent / "src"))

from schema import SchemaBuilder
from record_structures import DelimiterRecord
from file_manager import DataStorage


def quick_start_1():
    """Quickest possible start: Save some data"""
    print("\n=== QUICK START 1: Basic Save/Load ===\n")

    # 1. Define schema
    schema = SchemaBuilder("contacts")\
        .add_fixed_size_field("id", 5)\
        .add_delimiter_field("name", "|")\
        .add_delimiter_field("phone", "|")\
        .build()

    # 2. Create record structure
    record = DelimiterRecord("contact_record", schema, "\n")

    # 3. Prepare data
    data = [
        {"id": "C0001", "name": "Alice", "phone": "555-1234"},
        {"id": "C0002", "name": "Bob", "phone": "555-5678"},
    ]

    # 4. Save
    storage = DataStorage("saves")
    storage.register_structure(record)
    path = storage.save_data("contact_record", data, "contacts_export")

    print(f"[OK] Data saved to: {path}")
    print(f"[OK] File size: {path.stat().st_size} bytes")

    # 5. Load back
    loaded = storage.load_data("contact_record", path)
    print(f"[OK] Loaded {len(loaded)} records")
    for rec in loaded:
        print(f"  - {rec}")


def quick_start_2():
    """Working with dynamic configurations"""
    print("\n=== QUICK START 2: Dynamic Configuration ===\n")

    # Imagine this comes from your Flutter frontend
    config = {
        "schema_name": "user_form",
        "fields": [
            {"name": "username", "type": "fixed_size", "size": 20},
            {"name": "email", "type": "delimiter", "delimiter": "|"},
            {"name": "preferences", "type": "key_value", "pair_delimiter": "=", "field_delimiter": "&"},
        ]
    }

    # Build schema from config
    schema = SchemaBuilder(config["schema_name"])

    from field_structures import (
        FixedSizeField,
        DelimiterField,
        KeyValueField,
    )

    for field_config in config["fields"]:
        ftype = field_config["type"]

        if ftype == "fixed_size":
            schema.schema.add_field(
                FixedSizeField(
                    field_config["name"],
                    field_config["size"],
                )
            )
        elif ftype == "delimiter":
            schema.schema.add_field(
                DelimiterField(
                    field_config["name"],
                    field_config["delimiter"],
                )
            )
        elif ftype == "key_value":
            schema.schema.add_field(
                KeyValueField(
                    field_config["name"],
                    field_config["pair_delimiter"],
                    field_config["field_delimiter"],
                )
            )

    schema = schema.build()

    # Use it
    record = DelimiterRecord("user_form_record", schema, "\n")

    data = [
        {
            "username": "alice_wonder",
            "email": "alice@example.com",
            "preferences": {"theme": "dark", "notifications": "on"},
        },
    ]

    storage = DataStorage("saves")
    storage.register_structure(record)
    path = storage.save_data("user_form_record", data, "users_survey_001")

    print(f"[OK] Configuration applied and data saved")
    print(f"[OK] Saved to: {path}")

    # Show the config can be saved too
    import json
    config_path = Path("saves") / "configs" / "user_form.json"
    config_path.parent.mkdir(parents=True, exist_ok=True)
    with open(config_path, "w") as f:
        json.dump(config, f, indent=2)
    print(f"[OK] Configuration saved to: {config_path}")


def quick_start_3():
    """Building and organizing data"""
    print("\n=== QUICK START 3: Data Organization ===\n")

    schema = SchemaBuilder("products")\
        .add_delimiter_field("sku", "|")\
        .add_delimiter_field("name", "|")\
        .add_delimiter_field("price", "|")\
        .build()

    record = DelimiterRecord("product_record", schema, "\n")

    # Create multiple batches
    batches = [
        [
            {"sku": "SKU001", "name": "Laptop", "price": "999"},
            {"sku": "SKU002", "name": "Mouse", "price": "29"},
        ],
        [
            {"sku": "SKU003", "name": "Keyboard", "price": "79"},
            {"sku": "SKU004", "name": "Monitor", "price": "299"},
        ],
    ]

    storage = DataStorage("saves")
    storage.register_structure(record)

    print("Saving data batches with date organization...\n")

    for i, batch in enumerate(batches, 1):
        path = storage.save_data(
            "product_record",
            batch,
            f"products_batch_{i:03d}",
            organize_by_date=True
        )
        print(f"[OK] Batch {i} saved: {path}")

    # List all saved files
    print("\nAll saved product files:")
    files = storage.list_saved_files("product_record")
    for file_info in files:
        print(f"  - {file_info['file']}")
        print(f"    Records: {file_info['record_count']}")
        print(f"    Size: {file_info['file_size']} bytes")


def quick_start_4():
    """Appending to existing files"""
    print("\n=== QUICK START 4: Append Records ===\n")

    schema = SchemaBuilder("logs")\
        .add_delimiter_field("timestamp", "|")\
        .add_delimiter_field("level", "|")\
        .add_delimiter_field("message", "|")\
        .build()

    record = DelimiterRecord("log_record", schema, "\n")

    storage = DataStorage("saves")
    storage.register_structure(record)

    # Initial data
    initial_data = [
        {"timestamp": "2024-01-10 10:00", "level": "INFO", "message": "App started"},
    ]

    path = storage.save_data("log_record", initial_data, "app_logs", organize_by_date=False)
    print(f"[OK] Initial log file created: {path}")

    # Append more records
    new_records = [
        {"timestamp": "2024-01-10 10:05", "level": "INFO", "message": "User logged in"},
        {"timestamp": "2024-01-10 10:10", "level": "WARNING", "message": "High memory usage"},
        {"timestamp": "2024-01-10 10:15", "level": "ERROR", "message": "Database connection failed"},
    ]

    print("\nAppending records...\n")
    for new_record in new_records:
        storage.append_data("log_record", new_record, path)
        print(f"[OK] Appended: {new_record['message']}")

    # Read all
    print("\nReading all records:")
    all_records = storage.load_data("log_record", path)
    for i, rec in enumerate(all_records, 1):
        print(f"  {i}. [{rec['level']}] {rec['timestamp']} - {rec['message']}")


def main():
    """Run all quick starts"""
    print("\n" + "="*60)
    print("QUICK START GUIDE - Dynamic Fields & Records System")
    print("="*60)

    quick_start_1()
    quick_start_2()
    quick_start_3()
    quick_start_4()

    print("\n" + "="*60)
    print("[OK] ALL QUICK STARTS COMPLETED")
    print("="*60)
    print("\nNext steps:")
    print("  1. Check the 'saves' folder for generated files")
    print("  2. Review examples.py for more advanced usage")
    print("  3. Read README.md for complete documentation")
    print("  4. Customize field/record structures for your needs")


if __name__ == "__main__":
    main()
