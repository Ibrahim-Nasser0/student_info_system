class FileHeader:
    def __init__(self, format_type, record_count=0, version=1.0):
        self.format_type = format_type
        self.record_count = record_count
        self.version = version

    def serialize(self):
        return f"{self.format_type}|{self.record_count}|{self.version}\n"

    @staticmethod
    def deserialize(line):
        format_type, count, version = line.strip().split("|")
        return FileHeader(format_type, int(count), float(version))
