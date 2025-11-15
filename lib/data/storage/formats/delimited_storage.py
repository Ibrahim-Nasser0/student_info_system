class DelimitedStorage:
    def __init__(self, delimiter="|"):
        self.delimiter = delimiter

    def serialize_record(self, student_dict):
        return f"{student_dict['id']}{self.delimiter}{student_dict['name']}{self.delimiter}{student_dict['gpa']}\n"

    def deserialize_record(self, line):
        parts = line.strip().split(self.delimiter)
        return {
            "id": parts[0],
            "name": parts[1],
            "gpa": parts[2],
        }
