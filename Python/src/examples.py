"""
Comprehensive Examples and Demo Usage
Shows how to use all the field and record structures
"""

from schema import FieldSchema, SchemaBuilder
from record_structures import (
    FixedSizeRecord,
    DelimiterRecord,
    PreKnownFieldsRecord,
    IndexedRecord,
    RecordBuilder,
)
from file_manager import DataStorage
from pathlib import Path
import json


def example_1_fixed_size_fields_and_records():
    """Example 1: Fixed-size fields with fixed-size records"""
    print("\n" + "="*60)
    print("EXAMPLE 1: Fixed-Size Fields & Records")
    print("="*60)

    # Create schema with fixed-size fields
    schema = SchemaBuilder("user_fixed_schema")\
        .add_fixed_size_field("user_id", 10, "string")\
        .add_fixed_size_field("name", 50, "string")\
        .add_fixed_size_field("age", 3, "string")\
        .add_fixed_size_field("email", 100, "string")\
        .build()

    print(f"Schema: {schema.schema_name}")
    print(f"Field count: {schema.get_field_count()}")
    print("Fields:")
    for field in schema.get_fields():
        print(f"  - {field.name}: {field.get_metadata()}")

    # Create fixed-size record structure
    record_structure = FixedSizeRecord("user_record_fixed", schema)
    print(f"\nRecord size: {record_structure.record_size} bytes")

    # Create some records
    records = [
        {
            "user_id": "USER001",
            "name": "Alice Smith",
            "age": "28",
            "email": "alice@example.com",
        },
        {
            "user_id": "USER002",
            "name": "Bob Johnson",
            "age": "35",
            "email": "bob@example.com",
        },
        {
            "user_id": "USER003",
            "name": "Charlie Brown",
            "age": "42",
            "email": "charlie@example.com",
        },
    ]

    print(f"\nOriginal records: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Encode records
    print("\nEncoding records...")
    encoded_records = [record_structure.encode_record(record) for record in records]

    # Decode records back
    print("Decoding records...")
    decoded_records = []
    for encoded in encoded_records:
        decoded, _ = record_structure.decode_record(encoded)
        decoded_records.append(decoded)

    print(f"\nDecoded records: {len(decoded_records)}")
    for i, record in enumerate(decoded_records):
        print(f"  {i+1}. {record}")

    # Save using DataStorage
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "user_record_fixed",
        records,
        "users_fixed_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")

    # Load back
    loaded_records = storage.load_data("user_record_fixed", file_path)
    print(f"Loaded records: {len(loaded_records)}")


def example_2_delimiter_fields_and_records():
    """Example 2: Delimiter-based fields with delimiter records"""
    print("\n" + "="*60)
    print("EXAMPLE 2: Delimiter Fields & Records")
    print("="*60)

    # Create schema with delimiter fields
    schema = SchemaBuilder("product_delimiter_schema")\
        .add_delimiter_field("product_id", "|", "string")\
        .add_delimiter_field("name", "|", "string")\
        .add_delimiter_field("price", "|", "string")\
        .add_delimiter_field("quantity", "|", "string")\
        .build()

    print(f"Schema: {schema.schema_name}")
    print(f"Field count: {schema.get_field_count()}")

    # Create delimiter record structure
    record_structure = DelimiterRecord("product_record_delim", schema, record_delimiter="\n")

    # Create records
    records = [
        {
            "product_id": "PROD001",
            "name": "Laptop",
            "price": "999.99",
            "quantity": "5",
        },
        {
            "product_id": "PROD002",
            "name": "Mouse",
            "price": "29.99",
            "quantity": "50",
        },
        {
            "product_id": "PROD003",
            "name": "Keyboard",
            "price": "79.99",
            "quantity": "30",
        },
    ]

    print(f"\nOriginal records: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Encode and show as text
    print("\nEncoded data (showing first 200 chars):")
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)
    print(full_encoded[:200].decode("utf-8", errors="ignore"))

    # Decode
    decoded_records = []
    offset = 0
    while offset < len(full_encoded):
        try:
            decoded, consumed = record_structure.decode_record(full_encoded[offset:])
            decoded_records.append(decoded)
            offset += consumed
        except ValueError:
            break

    print(f"\nDecoded records: {len(decoded_records)}")
    for i, record in enumerate(decoded_records):
        print(f"  {i+1}. {record}")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "product_record_delim",
        records,
        "products_delim_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")


def example_3_length_indicator_fields():
    """Example 3: Length-indicator fields for variable-length data"""
    print("\n" + "="*60)
    print("EXAMPLE 3: Length-Indicator Fields")
    print("="*60)

    # Create schema with length-indicator fields
    schema = SchemaBuilder("document_schema")\
        .add_length_indicator_field("doc_id", 4, "string")\
        .add_length_indicator_field("title", 4, "string")\
        .add_length_indicator_field("content", 4, "string")\
        .build()

    print(f"Schema: {schema.schema_name}")

    # Create record structure
    record_structure = DelimiterRecord("document_record", schema, record_delimiter="\n")

    # Create records with variable-length data
    records = [
        {
            "doc_id": "DOC001",
            "title": "Introduction to Python",
            "content": "Python is a high-level programming language...",
        },
        {
            "doc_id": "DOC002",
            "title": "Web Development",
            "content": "Web development involves HTML, CSS, and JavaScript for frontend development, and Python, Node.js, or other languages for backend.",
        },
    ]

    print(f"\nOriginal records: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Encode
    print("\nEncoding records...")
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)

    print(f"Total encoded size: {len(full_encoded)} bytes")

    # Decode
    decoded_records = []
    offset = 0
    while offset < len(full_encoded):
        try:
            decoded, consumed = record_structure.decode_record(full_encoded[offset:])
            decoded_records.append(decoded)
            offset += consumed
        except ValueError:
            break

    print(f"\nDecoded records: {len(decoded_records)}")
    for i, record in enumerate(decoded_records):
        print(f"  {i+1}. {record}")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "document_record",
        records,
        "documents_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")


def example_4_key_value_fields():
    """Example 4: Key-value fields for flexible data"""
    print("\n" + "="*60)
    print("EXAMPLE 4: Key-Value Fields")
    print("="*60)

    # Create schema with key-value field
    schema = SchemaBuilder("config_schema")\
        .add_delimiter_field("device_id", "|", "string")\
        .add_key_value_field("settings", "=", "&", "string")\
        .build()

    print(f"Schema: {schema.schema_name}")

    # Create record structure
    record_structure = DelimiterRecord("config_record", schema, record_delimiter="\n")

    # Create records with key-value settings
    records = [
        {
            "device_id": "DEV001",
            "settings": {
                "brightness": "80",
                "volume": "50",
                "language": "en",
            },
        },
        {
            "device_id": "DEV002",
            "settings": {
                "brightness": "100",
                "volume": "75",
                "language": "es",
                "timezone": "EST",
            },
        },
    ]

    print(f"\nOriginal records: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Encode
    print("\nEncoding records...")
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)

    print(f"Total encoded size: {len(full_encoded)} bytes")
    print(f"Encoded data: {full_encoded.decode('utf-8', errors='ignore')}")

    # Decode
    decoded_records = []
    offset = 0
    while offset < len(full_encoded):
        try:
            decoded, consumed = record_structure.decode_record(full_encoded[offset:])
            decoded_records.append(decoded)
            offset += consumed
        except ValueError:
            break

    print(f"\nDecoded records: {len(decoded_records)}")
    for i, record in enumerate(decoded_records):
        print(f"  {i+1}. {record}")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "config_record",
        records,
        "devices_config_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")


def example_5_indexed_records():
    """Example 5: Indexed records for fast lookup"""
    print("\n" + "="*60)
    print("EXAMPLE 5: Indexed Records")
    print("="*60)

    # Create schema
    schema = SchemaBuilder("indexed_schema")\
        .add_fixed_size_field("id", 5, "string")\
        .add_delimiter_field("name", "|", "string")\
        .add_delimiter_field("score", "|", "string")\
        .build()

    # Create indexed record structure
    record_structure = IndexedRecord("indexed_scores", schema, record_delimiter="\n")

    # Create records
    records = [
        {"id": "ID001", "name": "Alice", "score": "95"},
        {"id": "ID002", "name": "Bob", "score": "87"},
        {"id": "ID003", "name": "Charlie", "score": "92"},
        {"id": "ID004", "name": "Diana", "score": "88"},
        {"id": "ID005", "name": "Eve", "score": "99"},
    ]

    print(f"Original records: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Encode all records
    print("\nEncoding records...")
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)

    print(f"Total encoded size: {len(full_encoded)} bytes")

    # Build index
    print("Building index...")
    record_structure.build_index(full_encoded)
    print(f"Index built: {record_structure.get_record_count()} records")

    # Show index
    print("Index contents:")
    for i, (offset, size) in enumerate(record_structure.index):
        print(f"  Record {i}: offset={offset}, size={size}")

    # Access record by index
    print("\nAccessing specific records by index:")
    for i in [0, 2, 4]:
        record = record_structure.get_record_at_index(full_encoded, i)
        print(f"  Record {i}: {record}")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "indexed_scores",
        records,
        "scores_indexed_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")


def example_6_dynamic_schema_builder():
    """Example 6: Dynamic schema building for changing requirements"""
    print("\n" + "="*60)
    print("EXAMPLE 6: Dynamic Schema Builder")
    print("="*60)

    print("Building schema dynamically based on requirements...")

    # Simulate receiving field configurations from external source (like Flutter frontend)
    field_configs = [
        {
            "name": "transaction_id",
            "type": "fixed_size",
            "size": 20,
            "data_type": "string",
        },
        {
            "name": "amount",
            "type": "length_indicator",
            "length_size": 2,
            "data_type": "string",
        },
        {
            "name": "merchant_info",
            "type": "key_value",
            "pair_delimiter": ":",
            "field_delimiter": ";",
            "data_type": "string",
        },
        {
            "name": "timestamp",
            "type": "delimiter",
            "delimiter": "|",
            "data_type": "string",
        },
    ]

    # Build schema from configs
    schema = FieldSchema("transaction_schema")
    from field_structures import (
        FixedSizeField,
        LengthIndicatorField,
        KeyValueField,
        DelimiterField,
    )

    for config in field_configs:
        field_type = config.get("type")

        if field_type == "fixed_size":
            field = FixedSizeField(config["name"], config["size"], config.get("data_type", "string"))
        elif field_type == "length_indicator":
            field = LengthIndicatorField(config["name"], config.get("length_size", 4), config.get("data_type", "string"))
        elif field_type == "key_value":
            field = KeyValueField(
                config["name"],
                config.get("pair_delimiter", "="),
                config.get("field_delimiter", "&"),
                config.get("data_type", "string"),
            )
        elif field_type == "delimiter":
            field = DelimiterField(config["name"], config.get("delimiter", "|"), config.get("data_type", "string"))

        schema.add_field(field)

    print(f"\nDynamically built schema: {schema.schema_name}")
    print(f"Fields: {schema.get_field_count()}")
    for field in schema.get_fields():
        print(f"  - {field.name}: {field.get_metadata()}")

    # Use the dynamic schema
    record_structure = DelimiterRecord("dynamic_transaction", schema, record_delimiter="\n")

    records = [
        {
            "transaction_id": "TXN202401010001",
            "amount": "150.50",
            "merchant_info": {
                "name": "Store ABC",
                "location": "Downtown",
            },
            "timestamp": "2024-01-01T10:30:00",
        },
        {
            "transaction_id": "TXN202401010002",
            "amount": "75.25",
            "merchant_info": {
                "name": "Cafe XYZ",
                "location": "Airport",
                "code": "12345",
            },
            "timestamp": "2024-01-01T11:45:00",
        },
    ]

    print(f"\nRecords: {len(records)}")
    for i, record in enumerate(records):
        print(f"  {i+1}. {record}")

    # Save dynamic schema config
    schema_file = Path("saves") / "schemas" / "transaction_schema.json"
    schema_file.parent.mkdir(parents=True, exist_ok=True)
    with open(schema_file, "w") as f:
        f.write(schema.to_json())
    print(f"\nSchema saved to: {schema_file}")

    # Encode records
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)

    print(f"Encoded data size: {len(full_encoded)} bytes")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "dynamic_transaction",
        records,
        "transactions_dynamic_001",
        organize_by_date=True
    )
    print(f"Saved to: {file_path}")


def example_7_mixed_field_types():
    """Example 7: Using multiple field types in one schema"""
    print("\n" + "="*60)
    print("EXAMPLE 7: Mixed Field Types")
    print("="*60)

    # Create schema with all field types
    schema = SchemaBuilder("employee_schema")\
        .add_fixed_size_field("emp_id", 8, "string")\
        .add_delimiter_field("name", "|", "string")\
        .add_fixed_size_field("age", 3, "string")\
        .add_length_indicator_field("bio", 2, "string")\
        .add_key_value_field("skills", ":", ",", "string")\
        .build()

    print(f"Schema: {schema.schema_name}")
    print("Fields with mixed types:")
    for field in schema.get_fields():
        meta = field.get_metadata()
        print(f"  - {field.name} ({meta.get('type', 'unknown')})")

    # Create record structure
    record_structure = DelimiterRecord("employee_record", schema, record_delimiter="\n")

    # Create records
    records = [
        {
            "emp_id": "EMP00001",
            "name": "John Doe",
            "age": "32",
            "bio": "Senior Python developer with 10 years experience",
            "skills": {
                "Python": "Expert",
                "SQL": "Advanced",
                "AWS": "Intermediate",
            },
        },
        {
            "emp_id": "EMP00002",
            "name": "Jane Smith",
            "age": "28",
            "bio": "Frontend specialist",
            "skills": {
                "React": "Expert",
                "JavaScript": "Expert",
                "CSS": "Advanced",
            },
        },
    ]

    print(f"\nRecords: {len(records)}")

    # Encode
    full_encoded = b""
    for record in records:
        full_encoded += record_structure.encode_record(record)

    print(f"Encoded size: {len(full_encoded)} bytes")

    # Decode
    decoded_records = []
    offset = 0
    while offset < len(full_encoded):
        try:
            decoded, consumed = record_structure.decode_record(full_encoded[offset:])
            decoded_records.append(decoded)
            offset += consumed
        except ValueError:
            break

    print(f"\nDecoded records: {len(decoded_records)}")
    for i, record in enumerate(decoded_records):
        print(f"  {i+1}. {record}")

    # Save
    storage = DataStorage(base_directory="saves")
    storage.register_structure(record_structure)

    file_path = storage.save_data(
        "employee_record",
        records,
        "employees_mixed_001",
        organize_by_date=True
    )
    print(f"\nSaved to: {file_path}")


def main():
    """Run all examples"""
    print("\n" + "="*60)
    print("OOP DYNAMIC FIELDS & RECORDS STRUCTURE SYSTEM")
    print("="*60)

    example_1_fixed_size_fields_and_records()
    example_2_delimiter_fields_and_records()
    example_3_length_indicator_fields()
    example_4_key_value_fields()
    example_5_indexed_records()
    example_6_dynamic_schema_builder()
    example_7_mixed_field_types()

    print("\n" + "="*60)
    print("ALL EXAMPLES COMPLETED")
    print("="*60)
    print("\nAll data has been saved to the 'saves' directory")
    print("Check the saves folder for output files and metadata")


if __name__ == "__main__":
    main()
