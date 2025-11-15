import os

class FileManager:
    def __init__(self, base_path="data/files"):
        self.base_path = base_path
        os.makedirs(base_path, exist_ok=True)

    def write(self, filename, data):
        with open(f"{self.base_path}/{filename}", "w", encoding="utf-8") as f:
            f.write(data)

    def read(self, filename):
        with open(f"{self.base_path}/{filename}", "r", encoding="utf-8") as f:
            return f.read()

    def append(self, filename, data):
        with open(f"{self.base_path}/{filename}", "a", encoding="utf-8") as f:
            f.write(data)

    def exists(self, filename):
        return os.path.exists(f"{self.base_path}/{filename}")
    