"""
Dynamic Fields and Record Structures Library
Complete OOP solution for flexible data serialization
"""

from field_structures import (
    FieldStructure,
    FixedSizeField,
    DelimiterField,
    KeyValueField,
    LengthIndicatorField,
)

from schema import FieldSchema, SchemaBuilder

from record_structures import (
    RecordStructure,
    FixedSizeRecord,
    DelimiterRecord,
    PreKnownFieldsRecord,
    IndexedRecord,
    RecordBuilder,
)

from file_manager import FileOrganizer, FileHandler, DataStorage

__version__ = "1.0.0"
__author__ = "Dynamic Structures Team"

__all__ = [
    # Field structures
    "FieldStructure",
    "FixedSizeField",
    "DelimiterField",
    "KeyValueField",
    "LengthIndicatorField",
    # Schema
    "FieldSchema",
    "SchemaBuilder",
    # Record structures
    "RecordStructure",
    "FixedSizeRecord",
    "DelimiterRecord",
    "PreKnownFieldsRecord",
    "IndexedRecord",
    "RecordBuilder",
    # File management
    "FileOrganizer",
    "FileHandler",
    "DataStorage",
]
