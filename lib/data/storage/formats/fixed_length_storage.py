class FixedLengthStorage:
    def __init__(self, record_size=50):
        self.record_size = record_size

    def serialize_record(self, student_dict):
        line = f"{student_dict['id']:<10}{student_dict['name']:<20}{student_dict['gpa']:<10}"
        return line[:self.record_size] + "\n"

    def deserialize_record(self, line):
        return {
            "id": line[0:10].strip(),
            "name": line[10:30].strip(),
            "gpa": line[30:40].strip(),
        }
