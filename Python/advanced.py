"""
Advanced Utilities and Helpers
Advanced features for power users
"""

import sys
from pathlib import Path
from typing import Dict, Any, List, Optional

sys.path.insert(0, str(Path(__file__).parent / "src"))

from schema import FieldSchema
from record_structures import RecordStructure, IndexedRecord
from file_manager import DataStorage
import json


class SchemaRegistry:
    """Registry for managing multiple schemas"""

    def __init__(self, registry_file: str = "saves/schemas/_registry.json"):
        self.registry_file = Path(registry_file)
        self.schemas: Dict[str, FieldSchema] = {}
        self.load_registry()

    def register_schema(self, schema: FieldSchema) -> None:
        """Register a schema"""
        self.schemas[schema.schema_name] = schema

    def get_schema(self, name: str) -> Optional[FieldSchema]:
        """Get a schema by name"""
        return self.schemas.get(name)

    def save_registry(self) -> None:
        """Save registry to file"""
        self.registry_file.parent.mkdir(parents=True, exist_ok=True)

        registry_data = {
            name: schema.to_dict()
            for name, schema in self.schemas.items()
        }

        with open(self.registry_file, "w") as f:
            json.dump(registry_data, f, indent=2)

    def load_registry(self) -> None:
        """Load registry from file"""
        if self.registry_file.exists():
            with open(self.registry_file, "r") as f:
                registry_data = json.load(f)

            for name, schema_dict in registry_data.items():
                schema = FieldSchema.from_dict(schema_dict)
                self.schemas[name] = schema

    def list_schemas(self) -> List[str]:
        """List all registered schema names"""
        return list(self.schemas.keys())


class DataMigrator:
    """Migrate data between different structures"""

    @staticmethod
    def convert_records(
        records: List[Dict[str, Any]],
        field_mapping: Dict[str, str],
    ) -> List[Dict[str, Any]]:
        """
        Convert records using field mapping

        Args:
            records: Source records
            field_mapping: Dict mapping source fields to target fields

        Returns:
            Converted records
        """
        converted = []

        for record in records:
            new_record = {}
            for source_field, target_field in field_mapping.items():
                if source_field in record:
                    new_record[target_field] = record[source_field]
            converted.append(new_record)

        return converted

    @staticmethod
    def filter_records(
        records: List[Dict[str, Any]],
        field_name: str,
        predicate,
    ) -> List[Dict[str, Any]]:
        """Filter records by field value"""
        return [
            record for record in records
            if field_name in record and predicate(record[field_name])
        ]

    @staticmethod
    def merge_records(
        records1: List[Dict[str, Any]],
        records2: List[Dict[str, Any]],
        merge_key: str,
    ) -> List[Dict[str, Any]]:
        """Merge two record sets by key"""
        merged = []
        record_map = {r.get(merge_key): r for r in records1}

        for record in records2:
            key = record.get(merge_key)
            if key in record_map:
                record_map[key].update(record)

        merged = list(record_map.values())
        return merged


class DataAnalyzer:
    """Analyze data in files"""

    @staticmethod
    def get_file_statistics(
        storage: DataStorage,
        structure_name: str,
        file_path: Path,
    ) -> Dict[str, Any]:
        """Get statistics about a file"""
        records = storage.load_data(structure_name, file_path)

        stats = {
            "record_count": len(records),
            "file_size": file_path.stat().st_size,
            "avg_record_size": file_path.stat().st_size // len(records) if records else 0,
            "field_count": len(records[0]) if records else 0,
            "fields": list(records[0].keys()) if records else [],
        }

        return stats

    @staticmethod
    def get_field_statistics(
        records: List[Dict[str, Any]],
        field_name: str,
    ) -> Dict[str, Any]:
        """Get statistics about a specific field"""
        if not records or field_name not in records[0]:
            return {}

        values = [r.get(field_name) for r in records if field_name in r]

        stats = {
            "field_name": field_name,
            "total_values": len(values),
            "unique_values": len(set(values)),
            "null_count": sum(1 for v in values if v is None or v == ""),
        }

        try:
            numeric_values = [float(v) for v in values if v]
            if numeric_values:
                stats.update({
                    "min": min(numeric_values),
                    "max": max(numeric_values),
                    "avg": sum(numeric_values) / len(numeric_values),
                })
        except (ValueError, TypeError):
            pass

        return stats


class BatchProcessor:
    """Process records in batches"""

    def __init__(self, batch_size: int = 1000):
        self.batch_size = batch_size

    def process_file_in_batches(
        self,
        storage: DataStorage,
        structure_name: str,
        file_path: Path,
        processor,
    ) -> List[Any]:
        """
        Process records in a file in batches

        Args:
            storage: DataStorage instance
            structure_name: Name of structure
            file_path: Path to file
            processor: Function to call for each batch

        Returns:
            List of results from processor
        """
        records = storage.load_data(structure_name, file_path)
        results = []

        for i in range(0, len(records), self.batch_size):
            batch = records[i:i + self.batch_size]
            result = processor(batch)
            results.append(result)

        return results

    def split_into_files(
        self,
        storage: DataStorage,
        structure_name: str,
        records: List[Dict[str, Any]],
        base_filename: str,
    ) -> List[Path]:
        """
        Split records into multiple files based on batch size

        Returns:
            List of created file paths
        """
        structure = storage.get_structure(structure_name)
        if not structure:
            raise ValueError(f"Structure {structure_name} not found")

        file_paths = []

        for i, batch_num in enumerate(range(0, len(records), self.batch_size)):
            batch = records[batch_num:batch_num + self.batch_size]
            filename = f"{base_filename}_batch_{i+1:04d}"

            path = storage.save_data(
                structure_name,
                batch,
                filename,
                organize_by_date=True,
            )
            file_paths.append(path)

        return file_paths


class QueryBuilder:
    """Build and execute queries on stored data"""

    def __init__(self, storage: DataStorage):
        self.storage = storage
        self.filters = []
        self.sorts = []

    def add_filter(self, field_name: str, operator: str, value: Any) -> "QueryBuilder":
        """Add a filter condition"""
        self.filters.append((field_name, operator, value))
        return self

    def add_sort(self, field_name: str, descending: bool = False) -> "QueryBuilder":
        """Add a sort condition"""
        self.sorts.append((field_name, descending))
        return self

    def execute(
        self,
        structure_name: str,
        file_path: Path,
    ) -> List[Dict[str, Any]]:
        """Execute the query"""
        records = self.storage.load_data(structure_name, file_path)

        # Apply filters
        for field_name, operator, value in self.filters:
            records = self._apply_filter(records, field_name, operator, value)

        # Apply sorts
        for field_name, descending in self.sorts:
            records = sorted(
                records,
                key=lambda r: r.get(field_name, ""),
                reverse=descending,
            )

        return records

    @staticmethod
    def _apply_filter(
        records: List[Dict[str, Any]],
        field_name: str,
        operator: str,
        value: Any,
    ) -> List[Dict[str, Any]]:
        """Apply a single filter"""
        filtered = []

        for record in records:
            field_value = record.get(field_name)

            if operator == "==":
                if field_value == value:
                    filtered.append(record)

            elif operator == "!=":
                if field_value != value:
                    filtered.append(record)

            elif operator == ">":
                try:
                    if float(field_value) > float(value):
                        filtered.append(record)
                except (ValueError, TypeError):
                    pass

            elif operator == "<":
                try:
                    if float(field_value) < float(value):
                        filtered.append(record)
                except (ValueError, TypeError):
                    pass

            elif operator == ">=":
                try:
                    if float(field_value) >= float(value):
                        filtered.append(record)
                except (ValueError, TypeError):
                    pass

            elif operator == "<=":
                try:
                    if float(field_value) <= float(value):
                        filtered.append(record)
                except (ValueError, TypeError):
                    pass

            elif operator == "in":
                if field_value in value:
                    filtered.append(record)

            elif operator == "contains":
                if value in str(field_value):
                    filtered.append(record)

        return filtered


# Example usage
if __name__ == "__main__":
    print("\n" + "="*70)
    print("ADVANCED UTILITIES DEMO")
    print("="*70)

    # Example 1: Schema Registry
    print("\n--- Schema Registry ---\n")

    registry = SchemaRegistry()

    from src import SchemaBuilder
    schema = SchemaBuilder("test_schema")\
        .add_fixed_size_field("id", 5)\
        .add_delimiter_field("name", "|")\
        .build()

    registry.register_schema(schema)
    registry.save_registry()

    print(f"Registered schemas: {registry.list_schemas()}")

    # Example 2: Data Analyzer
    print("\n--- Data Analyzer ---\n")

    records = [
        {"id": "1", "name": "Alice", "age": "28"},
        {"id": "2", "name": "Bob", "age": "35"},
        {"id": "3", "name": "Charlie", "age": "42"},
    ]

    analyzer = DataAnalyzer()
    field_stats = analyzer.get_field_statistics(records, "age")
    print(f"Age statistics: {field_stats}")

    # Example 3: Data Migration
    print("\n--- Data Migration ---\n")

    mapping = {"name": "full_name", "age": "years_old"}
    migrated = DataMigrator.convert_records(records, mapping)
    print(f"Migrated records: {migrated[0]}")

    # Example 4: Query Builder
    print("\n--- Query Builder ---\n")

    storage = DataStorage("saves")

    from src import DelimiterRecord
    record_struct = DelimiterRecord("query_test", schema, "\n")
    storage.register_structure(record_struct)

    path = storage.save_data("query_test", records, "query_demo")

    query = QueryBuilder(storage)\
        .add_filter("age", ">", "30")\
        .add_sort("name")

    results = query.execute("query_test", path)
    print(f"Query results (age > 30):")
    for r in results:
        print(f"  - {r}")

    print("\n" + "="*70)
