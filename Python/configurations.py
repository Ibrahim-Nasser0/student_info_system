"""
Example Configuration Schemas
JSON configurations that can be sent from Flutter frontend
"""

import json
from pathlib import Path

# Configuration examples that Flutter frontend could send


FLUTTER_CONFIGURATIONS = {
    # Example 1: Simple user registration form
    "user_registration": {
        "schema_name": "user_registration",
        "record_structure": "delimiter",
        "fields": [
            {
                "name": "user_id",
                "type": "fixed_size",
                "size": 10,
                "data_type": "string"
            },
            {
                "name": "username",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "email",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "age",
                "type": "fixed_size",
                "size": 3,
                "data_type": "string"
            }
        ]
    },

    # Example 2: Product inventory with key-value metadata
    "product_inventory": {
        "schema_name": "product_inventory",
        "record_structure": "delimiter",
        "fields": [
            {
                "name": "product_id",
                "type": "fixed_size",
                "size": 8,
                "data_type": "string"
            },
            {
                "name": "name",
                "type": "length_indicator",
                "length_size": 2,
                "data_type": "string"
            },
            {
                "name": "category",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "price",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "stock",
                "type": "fixed_size",
                "size": 5,
                "data_type": "string"
            },
            {
                "name": "attributes",
                "type": "key_value",
                "pair_delimiter": ":",
                "field_delimiter": ";",
                "data_type": "string"
            }
        ]
    },

    # Example 3: Fixed-size banking transaction (COBOL-like)
    "banking_transaction": {
        "schema_name": "banking_transaction",
        "record_structure": "fixed_size",
        "fields": [
            {
                "name": "transaction_id",
                "type": "fixed_size",
                "size": 12,
                "data_type": "string"
            },
            {
                "name": "account_number",
                "type": "fixed_size",
                "size": 16,
                "data_type": "string"
            },
            {
                "name": "transaction_type",
                "type": "fixed_size",
                "size": 3,
                "data_type": "string"
            },
            {
                "name": "amount",
                "type": "fixed_size",
                "size": 10,
                "data_type": "string"
            },
            {
                "name": "timestamp",
                "type": "fixed_size",
                "size": 14,
                "data_type": "string"
            }
        ]
    },

    # Example 4: Document/Article with rich metadata
    "article_storage": {
        "schema_name": "article_storage",
        "record_structure": "delimiter",
        "fields": [
            {
                "name": "article_id",
                "type": "fixed_size",
                "size": 10,
                "data_type": "string"
            },
            {
                "name": "title",
                "type": "length_indicator",
                "length_size": 2,
                "data_type": "string"
            },
            {
                "name": "author",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "content",
                "type": "length_indicator",
                "length_size": 4,
                "data_type": "string"
            },
            {
                "name": "tags",
                "type": "key_value",
                "pair_delimiter": ":",
                "field_delimiter": ",",
                "data_type": "string"
            },
            {
                "name": "published_date",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            }
        ]
    },

    # Example 5: IoT Sensor data (indexed for fast lookup)
    "iot_sensor_data": {
        "schema_name": "iot_sensor_data",
        "record_structure": "indexed",
        "fields": [
            {
                "name": "sensor_id",
                "type": "fixed_size",
                "size": 6,
                "data_type": "string"
            },
            {
                "name": "timestamp",
                "type": "fixed_size",
                "size": 13,
                "data_type": "string"
            },
            {
                "name": "temperature",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "humidity",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "sensor_status",
                "type": "key_value",
                "pair_delimiter": "=",
                "field_delimiter": "&",
                "data_type": "string"
            }
        ]
    },

    # Example 6: E-commerce Order
    "ecommerce_order": {
        "schema_name": "ecommerce_order",
        "record_structure": "delimiter",
        "fields": [
            {
                "name": "order_id",
                "type": "fixed_size",
                "size": 12,
                "data_type": "string"
            },
            {
                "name": "customer_id",
                "type": "fixed_size",
                "size": 10,
                "data_type": "string"
            },
            {
                "name": "order_date",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "items_json",
                "type": "length_indicator",
                "length_size": 4,
                "data_type": "string"
            },
            {
                "name": "totals",
                "type": "key_value",
                "pair_delimiter": ":",
                "field_delimiter": ";",
                "data_type": "string"
            },
            {
                "name": "shipping_address",
                "type": "length_indicator",
                "length_size": 3,
                "data_type": "string"
            }
        ]
    },

    # Example 7: Pre-known fields record (strict validation)
    "form_submission": {
        "schema_name": "form_submission",
        "record_structure": "pre_known_fields",
        "fields": [
            {
                "name": "submission_id",
                "type": "fixed_size",
                "size": 16,
                "data_type": "string"
            },
            {
                "name": "name",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "email",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "phone",
                "type": "delimiter",
                "delimiter": "|",
                "data_type": "string"
            },
            {
                "name": "message",
                "type": "length_indicator",
                "length_size": 2,
                "data_type": "string"
            }
        ]
    }
}


def save_configuration_examples():
    """Save all configuration examples to JSON files"""
    config_dir = Path("saves") / "configuration_examples"
    config_dir.mkdir(parents=True, exist_ok=True)

    for config_name, config_data in FLUTTER_CONFIGURATIONS.items():
        file_path = config_dir / f"{config_name}.json"
        with open(file_path, "w") as f:
            json.dump(config_data, f, indent=2)
        print(f"✓ Saved: {file_path}")


def print_configuration_examples():
    """Print all configuration examples"""
    print("\n" + "="*70)
    print("FLUTTER CONFIGURATION EXAMPLES")
    print("These configs can be sent from Flutter to configure data structures")
    print("="*70)

    for config_name, config_data in FLUTTER_CONFIGURATIONS.items():
        print(f"\n{'='*70}")
        print(f"Configuration: {config_name}")
        print(f"{'='*70}")
        print(json.dumps(config_data, indent=2))


if __name__ == "__main__":
    print("\nSaving configuration examples...")
    save_configuration_examples()

    print("\n" + "="*70)
    print("Configuration examples saved to: saves/configuration_examples/")
    print("="*70)

    # Also print to console
    print_configuration_examples()

    print("\n" + "="*70)
    print("These configurations can be:")
    print("  1. Sent from Flutter as JSON")
    print("  2. Parsed and used to build schemas dynamically")
    print("  3. Used to organize and serialize data")
    print("  4. Reused for consistent data formatting")
    print("="*70)
