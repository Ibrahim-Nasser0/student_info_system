# lib/data/models/student_model.py

class Student:
    def __init__(self, student_id, name, gpa):
        self.id = student_id
        self.name = name
        self.gpa = gpa

    def to_dict(self):
        return {"id": self.id, "name": self.name, "gpa": self.gpa}
