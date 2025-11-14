"""
Record Structure Classes
Defines different record encoding/decoding strategies
"""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Tuple, Optional
from schema import FieldSchema
import struct
import json


class RecordStructure(ABC):
    """Abstract base class for record structures"""

    def __init__(self, name: str, schema: FieldSchema):
        """
        Initialize a record structure

        Args:
            name: Record structure name
            schema: FieldSchema defining the fields
        """
        self.name = name
        self.schema = schema

    @abstractmethod
    def encode_record(self, record: Dict[str, Any]) -> bytes:
        """Encode a record (dictionary) to bytes"""
        pass

    @abstractmethod
    def decode_record(self, data: bytes) -> Tuple[Dict[str, Any], int]:
        """Decode bytes to record (dictionary), return (record, bytes_consumed)"""
        pass

    @abstractmethod
    def get_metadata(self) -> dict:
        """Get record structure metadata"""
        pass


class FixedSizeRecord(RecordStructure):
    """Fixed-size records where all records have same byte length"""

    def __init__(self, name: str, schema: FieldSchema):
        """
        Initialize fixed-size record

        Args:
            name: Record name
            schema: Schema with fixed-size fields
        """
        super().__init__(name, schema)
        self.record_size = self._calculate_size()

    def _calculate_size(self) -> int:
        """Calculate total fixed record size"""
        total_size = 0
        for field in self.schema.get_fields():
            if not hasattr(field, "size"):
                raise ValueError(f"Field '{field.name}' must have fixed size")
            total_size += field.size
        return total_size

    def encode_record(self, record: Dict[str, Any]) -> bytes:
        """Encode record to fixed-size bytes"""
        encoded = b""
        for field in self.schema.get_fields():
            value = record.get(field.name, "")
            encoded += field.encode(value)
        return encoded

    def decode_record(self, data: bytes) -> Tuple[Dict[str, Any], int]:
        """Decode fixed-size record"""
        if len(data) < self.record_size:
            raise ValueError(
                f"Not enough data for record: expected {self.record_size}, got {len(data)}"
            )

        record = {}
        offset = 0

        for field in self.schema.get_fields():
            value, consumed = field.decode(data[offset:])
            record[field.name] = value
            offset += consumed

        return record, self.record_size

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "fixed_size",
            "record_size": self.record_size,
            "schema": self.schema.to_dict(),
        }


class DelimiterRecord(RecordStructure):
    """Records separated by delimiters (variable length)"""

    def __init__(self, name: str, schema: FieldSchema, record_delimiter: str = "\n"):
        """
        Initialize delimiter-based record

        Args:
            name: Record name
            schema: FieldSchema with fields
            record_delimiter: Delimiter between records
        """
        super().__init__(name, schema)
        self.record_delimiter = record_delimiter

    def encode_record(self, record: Dict[str, Any]) -> bytes:
        """Encode record with field and record delimiters"""
        encoded = b""
        for field in self.schema.get_fields():
            value = record.get(field.name, "")
            encoded += field.encode(value)
        return encoded + self.record_delimiter.encode("utf-8")

    def decode_record(self, data: bytes) -> Tuple[Dict[str, Any], int]:
        """Decode delimiter-based record"""
        record_delim_bytes = self.record_delimiter.encode("utf-8")
        record_end = data.find(record_delim_bytes)

        if record_end == -1:
            raise ValueError(f"Record delimiter '{self.record_delimiter}' not found")

        record_data = data[:record_end]
        bytes_consumed = record_end + len(record_delim_bytes)

        record = {}
        offset = 0

        for field in self.schema.get_fields():
            value, consumed = field.decode(record_data[offset:])
            record[field.name] = value
            offset += consumed

        return record, bytes_consumed

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "delimiter",
            "record_delimiter": self.record_delimiter,
            "schema": self.schema.to_dict(),
        }


class PreKnownFieldsRecord(RecordStructure):
    """Records with pre-known field count for validation"""

    def __init__(self, name: str, schema: FieldSchema, record_delimiter: str = "\n"):
        """
        Initialize pre-known fields record

        Args:
            name: Record name
            schema: FieldSchema with known field count
            record_delimiter: Delimiter between records
        """
        super().__init__(name, schema)
        self.record_delimiter = record_delimiter
        self.expected_field_count = schema.get_field_count()

    def encode_record(self, record: Dict[str, Any]) -> bytes:
        """Encode record with field count validation"""
        # Verify all fields are present
        missing_fields = set(f.name for f in self.schema.get_fields()) - set(record.keys())
        if missing_fields:
            raise ValueError(f"Missing fields in record: {missing_fields}")

        encoded = b""
        for field in self.schema.get_fields():
            value = record[field.name]
            encoded += field.encode(value)

        return encoded + self.record_delimiter.encode("utf-8")

    def decode_record(self, data: bytes) -> Tuple[Dict[str, Any], int]:
        """Decode record with field count validation"""
        record_delim_bytes = self.record_delimiter.encode("utf-8")
        record_end = data.find(record_delim_bytes)

        if record_end == -1:
            raise ValueError(f"Record delimiter '{self.record_delimiter}' not found")

        record_data = data[:record_end]
        bytes_consumed = record_end + len(record_delim_bytes)

        record = {}
        offset = 0

        for field in self.schema.get_fields():
            value, consumed = field.decode(record_data[offset:])
            record[field.name] = value
            offset += consumed

        if len(record) != self.expected_field_count:
            raise ValueError(
                f"Field count mismatch: expected {self.expected_field_count}, got {len(record)}"
            )

        return record, bytes_consumed

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "pre_known_fields",
            "expected_field_count": self.expected_field_count,
            "record_delimiter": self.record_delimiter,
            "schema": self.schema.to_dict(),
        }


class IndexedRecord(RecordStructure):
    """Records with index file for quick lookup"""

    def __init__(self, name: str, schema: FieldSchema, record_delimiter: str = "\n"):
        """
        Initialize indexed record

        Args:
            name: Record name
            schema: FieldSchema
            record_delimiter: Delimiter between records
        """
        super().__init__(name, schema)
        self.record_delimiter = record_delimiter
        self.index: List[Tuple[int, int]] = []  # (offset, size) tuples

    def encode_record(self, record: Dict[str, Any]) -> bytes:
        """Encode record with index tracking"""
        encoded = b""
        for field in self.schema.get_fields():
            value = record.get(field.name, "")
            encoded += field.encode(value)

        full_record = encoded + self.record_delimiter.encode("utf-8")
        return full_record

    def decode_record(self, data: bytes) -> Tuple[Dict[str, Any], int]:
        """Decode indexed record"""
        record_delim_bytes = self.record_delimiter.encode("utf-8")
        record_end = data.find(record_delim_bytes)

        if record_end == -1:
            raise ValueError(f"Record delimiter '{self.record_delimiter}' not found")

        record_data = data[:record_end]
        bytes_consumed = record_end + len(record_delim_bytes)

        record = {}
        offset = 0

        for field in self.schema.get_fields():
            value, consumed = field.decode(record_data[offset:])
            record[field.name] = value
            offset += consumed

        return record, bytes_consumed

    def build_index(self, data: bytes) -> None:
        """Build index of record positions in data"""
        self.index = []
        offset = 0
        record_delim_bytes = self.record_delimiter.encode("utf-8")

        while offset < len(data):
            record_start = offset
            record_end = data.find(record_delim_bytes, offset)

            if record_end == -1:
                record_end = len(data)
                bytes_consumed = len(data) - offset
            else:
                bytes_consumed = record_end - offset + len(record_delim_bytes)

            self.index.append((record_start, bytes_consumed))
            offset = record_start + bytes_consumed

    def get_record_count(self) -> int:
        """Get number of indexed records"""
        return len(self.index)

    def get_record_at_index(self, data: bytes, index: int) -> Dict[str, Any]:
        """Get record at specific index"""
        if index >= len(self.index):
            raise IndexError(f"Record index out of range: {index}")

        offset, size = self.index[index]
        record, _ = self.decode_record(data[offset : offset + size])
        return record

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "indexed",
            "record_delimiter": self.record_delimiter,
            "index_size": len(self.index),
            "schema": self.schema.to_dict(),
        }


class RecordBuilder:
    """Builder for creating records from dictionaries"""

    def __init__(self, structure: RecordStructure):
        """Initialize record builder"""
        self.structure = structure
        self.record: Dict[str, Any] = {}

    def set_field(self, field_name: str, value: Any) -> "RecordBuilder":
        """Set a field value"""
        if self.structure.schema.get_field(field_name) is None:
            raise ValueError(f"Field '{field_name}' not found in schema")
        self.record[field_name] = value
        return self

    def set_fields(self, fields: Dict[str, Any]) -> "RecordBuilder":
        """Set multiple fields at once"""
        for name, value in fields.items():
            self.set_field(name, value)
        return self

    def build(self) -> bytes:
        """Build and encode the record"""
        return self.structure.encode_record(self.record)

    def get_record(self) -> Dict[str, Any]:
        """Get the record dictionary"""
        return self.record.copy()
