class VariableLengthStorage:
    def serialize_record(self, student_dict):
        body = f"{student_dict['id']}|{student_dict['name']}|{student_dict['gpa']}"
        return f"{len(body)}#{body}\n"

    def deserialize_record(self, line):
        length, body = line.strip().split("#")
        parts = body.split("|")
        return {
            "id": parts[0],
            "name": parts[1],
            "gpa": parts[2]
        }
