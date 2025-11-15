from ..storage.file_manager import FileManager

class StudentRepository:
    def __init__(self, storage_handler, filename="students.txt"):
        self.file = FileManager()
        self.filename = filename
        self.format = storage_handler

    def add_student(self, student):
        line = self.format.serialize_record(student.to_dict())
        self.file.append(self.filename, line)

    def get_all(self):
        lines = self.file.read(self.filename).splitlines()
        return [self.format.deserialize_record(line) for line in lines]
