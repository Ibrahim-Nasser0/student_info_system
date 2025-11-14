"""
Integration Utilities
Helper functions for integrating with Flutter or other frontends
"""

import json
from typing import Dict, Any, List
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent / "src"))

from schema import FieldSchema, SchemaBuilder
from field_structures import (
    FixedSizeField,
    DelimiterField,
    KeyValueField,
    LengthIndicatorField,
)
from record_structures import (
    FixedSizeRecord,
    DelimiterRecord,
    PreKnownFieldsRecord,
    IndexedRecord,
)
from file_manager import DataStorage


class ConfigurationHandler:
    """Handle configuration JSON from external sources like Flutter"""

    @staticmethod
    def build_schema_from_config(config: Dict[str, Any]) -> FieldSchema:
        """
        Build a FieldSchema from configuration dictionary

        Args:
            config: Configuration dict with schema_name and fields

        Returns:
            FieldSchema object
        """
        schema_name = config.get("schema_name", "unnamed_schema")
        schema = FieldSchema(schema_name)

        for field_config in config.get("fields", []):
            field = ConfigurationHandler._create_field_from_config(field_config)
            schema.add_field(field)

        return schema

    @staticmethod
    def _create_field_from_config(field_config: Dict[str, Any]):
        """Create a field object from configuration"""
        field_type = field_config.get("type")
        name = field_config.get("name")
        data_type = field_config.get("data_type", "string")

        if field_type == "fixed_size":
            return FixedSizeField(name, field_config.get("size"), data_type)

        elif field_type == "delimiter":
            return DelimiterField(name, field_config.get("delimiter", "|"), data_type)

        elif field_type == "key_value":
            return KeyValueField(
                name,
                field_config.get("pair_delimiter", "="),
                field_config.get("field_delimiter", "&"),
                data_type,
            )

        elif field_type == "length_indicator":
            return LengthIndicatorField(
                name,
                field_config.get("length_size", 4),
                data_type,
            )

        else:
            raise ValueError(f"Unknown field type: {field_type}")

    @staticmethod
    def build_record_structure_from_config(config: Dict[str, Any]) -> Any:
        """
        Build a RecordStructure from configuration

        Args:
            config: Configuration dict with record_structure type

        Returns:
            RecordStructure object
        """
        schema = ConfigurationHandler.build_schema_from_config(config)
        record_type = config.get("record_structure", "delimiter")
        structure_name = config.get("schema_name", "unnamed")

        if record_type == "fixed_size":
            return FixedSizeRecord(structure_name, schema)

        elif record_type == "delimiter":
            record_delimiter = config.get("record_delimiter", "\n")
            return DelimiterRecord(structure_name, schema, record_delimiter)

        elif record_type == "pre_known_fields":
            record_delimiter = config.get("record_delimiter", "\n")
            return PreKnownFieldsRecord(structure_name, schema, record_delimiter)

        elif record_type == "indexed":
            record_delimiter = config.get("record_delimiter", "\n")
            return IndexedRecord(structure_name, schema, record_delimiter)

        else:
            raise ValueError(f"Unknown record structure type: {record_type}")

    @staticmethod
    def config_from_json(json_string: str) -> Dict[str, Any]:
        """Parse JSON configuration string"""
        return json.loads(json_string)

    @staticmethod
    def config_to_json(config: Dict[str, Any]) -> str:
        """Convert configuration to JSON string"""
        return json.dumps(config, indent=2)


class IntegrationHelper:
    """High-level helper for integration tasks"""

    def __init__(self, base_directory: str = "saves"):
        """Initialize helper"""
        self.storage = DataStorage(base_directory)
        self.handler = ConfigurationHandler()

    def process_flutter_request(
        self,
        config_json: str,
        records: List[Dict[str, Any]],
        file_name: str,
        organize_by_date: bool = True,
    ) -> Dict[str, Any]:
        """
        Process a complete request from Flutter

        Args:
            config_json: Configuration as JSON string
            records: Records to save
            file_name: Output file name
            organize_by_date: Whether to organize in date folders

        Returns:
            Response dict with file info
        """
        # Parse configuration
        config = self.handler.config_from_json(config_json)

        # Build record structure
        record_structure = self.handler.build_record_structure_from_config(config)

        # Register structure
        self.storage.register_structure(record_structure)

        # Save data
        file_path = self.storage.save_data(
            record_structure.name,
            records,
            file_name,
            organize_by_date=organize_by_date,
        )

        # Return response
        return {
            "status": "success",
            "file_path": str(file_path),
            "file_size": file_path.stat().st_size,
            "record_count": len(records),
            "schema_name": config.get("schema_name"),
            "structure_type": config.get("record_structure", "delimiter"),
        }

    def load_data_by_config(
        self,
        config_json: str,
        file_path: str,
    ) -> List[Dict[str, Any]]:
        """
        Load data using a configuration

        Args:
            config_json: Configuration as JSON string
            file_path: Path to file to load

        Returns:
            List of loaded records
        """
        config = self.handler.config_from_json(config_json)
        record_structure = self.handler.build_record_structure_from_config(config)
        self.storage.register_structure(record_structure)

        return self.storage.load_data(record_structure.name, Path(file_path))

    def get_available_structures(self) -> Dict[str, Any]:
        """Get all registered structures"""
        return self.storage.list_structures()

    def get_saved_files_for_structure(self, structure_name: str) -> List[Dict[str, Any]]:
        """Get all saved files for a structure"""
        return self.storage.list_saved_files(structure_name)


class SchemaValidator:
    """Validate configuration schemas"""

    VALID_FIELD_TYPES = [
        "fixed_size",
        "delimiter",
        "key_value",
        "length_indicator",
    ]

    VALID_RECORD_TYPES = [
        "fixed_size",
        "delimiter",
        "pre_known_fields",
        "indexed",
    ]

    VALID_DATA_TYPES = [
        "string",
        "int",
        "float",
        "bytes",
    ]

    @classmethod
    def validate_config(cls, config: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validate a configuration

        Returns:
            Dict with validation result and errors
        """
        errors = []

        # Check required fields
        if "schema_name" not in config:
            errors.append("Missing required field: schema_name")

        if "fields" not in config or not isinstance(config["fields"], list):
            errors.append("Missing or invalid required field: fields (must be list)")
            return {"valid": False, "errors": errors}

        # Validate each field
        for i, field in enumerate(config["fields"]):
            field_errors = cls._validate_field(field, i)
            errors.extend(field_errors)

        # Validate record structure if present
        if "record_structure" in config:
            if config["record_structure"] not in cls.VALID_RECORD_TYPES:
                errors.append(
                    f"Invalid record_structure: {config['record_structure']}. "
                    f"Valid types: {', '.join(cls.VALID_RECORD_TYPES)}"
                )

        return {
            "valid": len(errors) == 0,
            "errors": errors,
            "warning_count": 0,
        }

    @classmethod
    def _validate_field(cls, field: Dict[str, Any], index: int) -> List[str]:
        """Validate a single field configuration"""
        errors = []

        if "name" not in field:
            errors.append(f"Field {index}: Missing 'name'")

        if "type" not in field:
            errors.append(f"Field {index}: Missing 'type'")
        elif field["type"] not in cls.VALID_FIELD_TYPES:
            errors.append(
                f"Field {index}: Invalid type '{field['type']}'. "
                f"Valid types: {', '.join(cls.VALID_FIELD_TYPES)}"
            )

        # Type-specific validation
        field_type = field.get("type")

        if field_type == "fixed_size":
            if "size" not in field or not isinstance(field["size"], int):
                errors.append(f"Field {index}: fixed_size requires integer 'size'")

        elif field_type == "key_value":
            if "pair_delimiter" not in field:
                errors.append(f"Field {index}: key_value requires 'pair_delimiter'")
            if "field_delimiter" not in field:
                errors.append(f"Field {index}: key_value requires 'field_delimiter'")

        elif field_type == "length_indicator":
            if "length_size" in field and not isinstance(field["length_size"], int):
                errors.append(f"Field {index}: 'length_size' must be integer")

        # Validate data_type if present
        if "data_type" in field and field["data_type"] not in cls.VALID_DATA_TYPES:
            errors.append(
                f"Field {index}: Invalid data_type '{field['data_type']}'. "
                f"Valid types: {', '.join(cls.VALID_DATA_TYPES)}"
            )

        return errors


# Example usage
if __name__ == "__main__":
    print("\n" + "="*70)
    print("INTEGRATION UTILITIES DEMO")
    print("="*70)

    # Example 1: Validate configuration
    print("\n--- Configuration Validation ---\n")

    sample_config = {
        "schema_name": "test_schema",
        "fields": [
            {"name": "id", "type": "fixed_size", "size": 10},
            {"name": "name", "type": "delimiter", "delimiter": "|"},
        ]
    }

    validation_result = SchemaValidator.validate_config(sample_config)
    print(f"Valid: {validation_result['valid']}")
    if validation_result["errors"]:
        for error in validation_result["errors"]:
            print(f"  ✗ {error}")
    else:
        print("  ✓ No errors found")

    # Example 2: Process Flutter request
    print("\n--- Processing Flutter Request ---\n")

    config_json = json.dumps(sample_config)

    records = [
        {"id": "ID001", "name": "Alice"},
        {"id": "ID002", "name": "Bob"},
    ]

    helper = IntegrationHelper("saves")

    response = helper.process_flutter_request(
        config_json=config_json,
        records=records,
        file_name="integration_test_001",
        organize_by_date=True,
    )

    print(f"Status: {response['status']}")
    print(f"File saved to: {response['file_path']}")
    print(f"Records saved: {response['record_count']}")
    print(f"File size: {response['file_size']} bytes")

    # Example 3: Load data back
    print("\n--- Loading Data Back ---\n")

    loaded = helper.load_data_by_config(config_json, response["file_path"])
    print(f"Loaded {len(loaded)} records:")
    for rec in loaded:
        print(f"  - {rec}")

    print("\n" + "="*70)
