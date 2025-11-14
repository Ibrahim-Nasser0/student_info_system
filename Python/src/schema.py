"""
Schema Definition and Management
Manages field configurations and schemas
"""

from typing import List, Dict, Any, Optional
from field_structures import (
    FieldStructure,
    FixedSizeField,
    DelimiterField,
    KeyValueField,
    LengthIndicatorField,
)
import json


class FieldSchema:
    """Schema definition for a set of fields"""

    def __init__(self, schema_name: str):
        """
        Initialize a field schema

        Args:
            schema_name: Name identifier for this schema
        """
        self.schema_name = schema_name
        self.fields: List[FieldStructure] = []
        self.field_map: Dict[str, FieldStructure] = {}

    def add_field(self, field: FieldStructure) -> None:
        """Add a field to the schema"""
        if field.name in self.field_map:
            raise ValueError(f"Field '{field.name}' already exists in schema")
        self.fields.append(field)
        self.field_map[field.name] = field

    def remove_field(self, field_name: str) -> None:
        """Remove a field from the schema"""
        if field_name not in self.field_map:
            raise ValueError(f"Field '{field_name}' not found in schema")
        field = self.field_map.pop(field_name)
        self.fields.remove(field)

    def get_field(self, field_name: str) -> Optional[FieldStructure]:
        """Get a field by name"""
        return self.field_map.get(field_name)

    def get_fields(self) -> List[FieldStructure]:
        """Get all fields in order"""
        return self.fields.copy()

    def get_field_count(self) -> int:
        """Get number of fields in schema"""
        return len(self.fields)

    def get_metadata(self) -> dict:
        """Get schema metadata"""
        return {
            "schema_name": self.schema_name,
            "field_count": len(self.fields),
            "fields": [field.get_metadata() for field in self.fields],
        }

    def to_dict(self) -> dict:
        """Convert schema to dictionary"""
        return {
            "schema_name": self.schema_name,
            "fields": [
                {
                    "name": field.name,
                    **field.get_metadata(),
                }
                for field in self.fields
            ],
        }

    def to_json(self) -> str:
        """Convert schema to JSON string"""
        return json.dumps(self.to_dict(), indent=2)

    @classmethod
    def from_dict(cls, schema_dict: dict) -> "FieldSchema":
        """Create schema from dictionary"""
        schema = cls(schema_dict["schema_name"])

        for field_config in schema_dict.get("fields", []):
            field = _create_field_from_config(field_config)
            schema.add_field(field)

        return schema

    @classmethod
    def from_json(cls, json_str: str) -> "FieldSchema":
        """Create schema from JSON string"""
        schema_dict = json.loads(json_str)
        return cls.from_dict(schema_dict)


def _create_field_from_config(config: dict) -> FieldStructure:
    """Helper function to create field from configuration"""
    field_type = config.get("type")
    name = config.get("name")

    if field_type == "fixed_size":
        return FixedSizeField(name, config.get("size"), config.get("data_type", "string"))

    elif field_type == "delimiter":
        return DelimiterField(name, config.get("delimiter", "|"), config.get("data_type", "string"))

    elif field_type == "key_value":
        return KeyValueField(
            name,
            config.get("pair_delimiter", "="),
            config.get("field_delimiter", "&"),
            config.get("data_type", "string"),
        )

    elif field_type == "length_indicator":
        return LengthIndicatorField(
            name,
            config.get("length_size", 4),
            config.get("data_type", "string"),
        )

    else:
        raise ValueError(f"Unknown field type: {field_type}")


class SchemaBuilder:
    """Builder class for constructing schemas dynamically"""

    def __init__(self, schema_name: str):
        """Initialize schema builder"""
        self.schema = FieldSchema(schema_name)

    def add_fixed_size_field(self, name: str, size: int, data_type: str = "string") -> "SchemaBuilder":
        """Add fixed-size field"""
        self.schema.add_field(FixedSizeField(name, size, data_type))
        return self

    def add_delimiter_field(self, name: str, delimiter: str = "|", data_type: str = "string") -> "SchemaBuilder":
        """Add delimiter-based field"""
        self.schema.add_field(DelimiterField(name, delimiter, data_type))
        return self

    def add_key_value_field(
        self,
        name: str,
        pair_delimiter: str = "=",
        field_delimiter: str = "&",
        data_type: str = "string",
    ) -> "SchemaBuilder":
        """Add key-value field"""
        self.schema.add_field(KeyValueField(name, pair_delimiter, field_delimiter, data_type))
        return self

    def add_length_indicator_field(self, name: str, length_size: int = 4, data_type: str = "string") -> "SchemaBuilder":
        """Add length-indicator field"""
        self.schema.add_field(LengthIndicatorField(name, length_size, data_type))
        return self

    def build(self) -> FieldSchema:
        """Build and return the schema"""
        return self.schema
