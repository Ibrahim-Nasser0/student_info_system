"""
Field Structure Classes
Defines different field encoding/decoding strategies
"""

from abc import ABC, abstractmethod
from typing import Any, Union
import struct


class FieldStructure(ABC):
    """Abstract base class for field structures"""

    def __init__(self, name: str, data_type: str = "string"):
        """
        Initialize a field structure

        Args:
            name: Field name identifier
            data_type: Type of data (string, int, float, bytes)
        """
        self.name = name
        self.data_type = data_type

    @abstractmethod
    def encode(self, value: Any) -> bytes:
        """Encode a value to bytes"""
        pass

    @abstractmethod
    def decode(self, data: bytes) -> tuple[Any, int]:
        """Decode bytes to value, return (value, bytes_consumed)"""
        pass

    @abstractmethod
    def get_metadata(self) -> dict:
        """Get field metadata for storage"""
        pass


class FixedSizeField(FieldStructure):
    """Field with fixed size in bytes"""

    def __init__(self, name: str, size: int, data_type: str = "string"):
        """
        Initialize a fixed-size field

        Args:
            name: Field name
            size: Fixed size in bytes
            data_type: Type of data
        """
        super().__init__(name, data_type)
        self.size = size

    def encode(self, value: Any) -> bytes:
        """Encode value to fixed-size bytes"""
        if self.data_type == "string":
            encoded = str(value).encode("utf-8")
            if len(encoded) > self.size:
                encoded = encoded[: self.size]
            elif len(encoded) < self.size:
                encoded = encoded + b"\x00" * (self.size - len(encoded))
            return encoded

        elif self.data_type == "int":
            return struct.pack(f"!{'q' if self.size >= 8 else 'i'}", int(value))[
                -self.size :
            ]

        elif self.data_type == "float":
            return struct.pack("!d", float(value))[: self.size]

        elif self.data_type == "bytes":
            if isinstance(value, bytes):
                data = value
            else:
                data = bytes(value)
            if len(data) > self.size:
                data = data[: self.size]
            elif len(data) < self.size:
                data = data + b"\x00" * (self.size - len(data))
            return data

        return b"\x00" * self.size

    def decode(self, data: bytes) -> tuple[Any, int]:
        """Decode fixed-size bytes to value"""
        if len(data) < self.size:
            raise ValueError(
                f"Not enough data for field '{self.name}': expected {self.size}, got {len(data)}"
            )

        field_data = data[: self.size]

        if self.data_type == "string":
            return field_data.rstrip(b"\x00").decode("utf-8", errors="ignore"), self.size

        elif self.data_type == "int":
            return struct.unpack("!q", b"\x00" * (8 - len(field_data)) + field_data)[
                0
            ], self.size

        elif self.data_type == "float":
            return struct.unpack("!d", field_data + b"\x00" * (8 - len(field_data)))[
                0
            ], self.size

        elif self.data_type == "bytes":
            return field_data.rstrip(b"\x00"), self.size

        return field_data, self.size

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "fixed_size",
            "size": self.size,
            "data_type": self.data_type,
        }


class DelimiterField(FieldStructure):
    """Field with delimiter-based separation"""

    def __init__(self, name: str, delimiter: str = "|", data_type: str = "string"):
        """
        Initialize a delimiter-based field

        Args:
            name: Field name
            delimiter: Delimiter character/string
            data_type: Type of data
        """
        super().__init__(name, data_type)
        self.delimiter = delimiter

    def encode(self, value: Any) -> bytes:
        """Encode value with trailing delimiter"""
        encoded = str(value).encode("utf-8")
        return encoded + self.delimiter.encode("utf-8")

    def decode(self, data: bytes) -> tuple[Any, int]:
        """Decode value up to delimiter"""
        delimiter_bytes = self.delimiter.encode("utf-8")
        index = data.find(delimiter_bytes)

        if index == -1:
            raise ValueError(f"Delimiter '{self.delimiter}' not found in data for field '{self.name}'")

        field_data = data[:index]
        bytes_consumed = index + len(delimiter_bytes)

        if self.data_type == "string":
            return field_data.decode("utf-8", errors="ignore"), bytes_consumed

        elif self.data_type == "int":
            return int(field_data.decode("utf-8")), bytes_consumed

        elif self.data_type == "float":
            return float(field_data.decode("utf-8")), bytes_consumed

        elif self.data_type == "bytes":
            return field_data, bytes_consumed

        return field_data, bytes_consumed

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "delimiter",
            "delimiter": self.delimiter,
            "data_type": self.data_type,
        }


class KeyValueField(FieldStructure):
    """Field with key=value format"""

    def __init__(self, name: str, pair_delimiter: str = "=", field_delimiter: str = "&", data_type: str = "string"):
        """
        Initialize a key-value field

        Args:
            name: Field name
            pair_delimiter: Delimiter between key and value
            field_delimiter: Delimiter between fields
            data_type: Type of data
        """
        super().__init__(name, data_type)
        self.pair_delimiter = pair_delimiter
        self.field_delimiter = field_delimiter

    def encode(self, value: dict) -> bytes:
        """Encode dictionary to key=value format"""
        pairs = []
        for k, v in value.items():
            pairs.append(f"{k}{self.pair_delimiter}{v}")
        encoded = self.field_delimiter.join(pairs).encode("utf-8")
        return encoded + self.field_delimiter.encode("utf-8")

    def decode(self, data: bytes) -> tuple[dict, int]:
        """Decode key=value format to dictionary"""
        field_delimiter_bytes = self.field_delimiter.encode("utf-8")
        index = data.find(field_delimiter_bytes)

        if index == -1:
            raise ValueError(f"Field delimiter not found in data for field '{self.name}'")

        field_data = data[:index].decode("utf-8", errors="ignore")
        bytes_consumed = index + len(field_delimiter_bytes)

        result = {}
        pairs = field_data.split(self.field_delimiter)
        for pair in pairs:
            if self.pair_delimiter in pair:
                k, v = pair.split(self.pair_delimiter, 1)
                result[k] = v

        return result, bytes_consumed

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "key_value",
            "pair_delimiter": self.pair_delimiter,
            "field_delimiter": self.field_delimiter,
            "data_type": self.data_type,
        }


class LengthIndicatorField(FieldStructure):
    """Field with length indicator prefix"""

    def __init__(self, name: str, length_size: int = 4, data_type: str = "string"):
        """
        Initialize a length-indicator field

        Args:
            name: Field name
            length_size: Size of length indicator in bytes
            data_type: Type of data
        """
        super().__init__(name, data_type)
        self.length_size = length_size

    def encode(self, value: Any) -> bytes:
        """Encode value with length prefix"""
        if isinstance(value, bytes):
            data = value
        else:
            data = str(value).encode("utf-8")

        length = len(data)
        if self.length_size == 1:
            length_bytes = struct.pack("!B", length)
        elif self.length_size == 2:
            length_bytes = struct.pack("!H", length)
        elif self.length_size == 4:
            length_bytes = struct.pack("!I", length)
        else:
            length_bytes = struct.pack("!Q", length)

        return length_bytes + data

    def decode(self, data: bytes) -> tuple[Any, int]:
        """Decode length-prefixed value"""
        if len(data) < self.length_size:
            raise ValueError(f"Not enough data for length indicator in field '{self.name}'")

        length_bytes = data[: self.length_size]

        if self.length_size == 1:
            length = struct.unpack("!B", length_bytes)[0]
        elif self.length_size == 2:
            length = struct.unpack("!H", length_bytes)[0]
        elif self.length_size == 4:
            length = struct.unpack("!I", length_bytes)[0]
        else:
            length = struct.unpack("!Q", length_bytes)[0]

        if len(data) < self.length_size + length:
            raise ValueError(
                f"Not enough data in field '{self.name}': expected {length}, got {len(data) - self.length_size}"
            )

        field_data = data[self.length_size : self.length_size + length]
        bytes_consumed = self.length_size + length

        if self.data_type == "string":
            return field_data.decode("utf-8", errors="ignore"), bytes_consumed

        elif self.data_type == "int":
            return int(field_data.decode("utf-8")), bytes_consumed

        elif self.data_type == "float":
            return float(field_data.decode("utf-8")), bytes_consumed

        elif self.data_type == "bytes":
            return field_data, bytes_consumed

        return field_data, bytes_consumed

    def get_metadata(self) -> dict:
        return {
            "name": self.name,
            "type": "length_indicator",
            "length_size": self.length_size,
            "data_type": self.data_type,
        }
