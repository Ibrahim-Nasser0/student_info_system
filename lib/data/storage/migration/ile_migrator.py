class FileMigrator:
    def __init__(self, source_format, target_format):
        self.source_format = source_format
        self.target_format = target_format

    def migrate(self, lines):
        output = []
        for line in lines:
            data = self.source_format.deserialize_record(line)
            output.append(self.target_format.serialize_record(data))
        return output
