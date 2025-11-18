class FileHeader {
  final int recordCount; // عدد السجلات الموجودة في الملف
  final double fileSize;
  final String createdAt; // تاريخ الإنشاء (سلسلة)
  final String lastModified; // تاريخ آخر تعديل (سلسلة)
  final String fileType;

  FileHeader({
    required this.recordCount,
    required this.createdAt,
    required this.lastModified,
    required this.fileSize,
    required this.fileType,
  });

  Map<String, String> toMap() => {
    'recordCount': recordCount.toString(),
    'createdAt': createdAt,
    'lastModified': lastModified,
    'fileSize': fileSize.toString(),
    'fileType': fileType,
  };

  // نقرأ header مِن خريطة
  factory FileHeader.fromMap(Map<String, String> map) {
    return FileHeader(
      recordCount: int.parse(map['recordCount'] ?? '0'),
      createdAt: map['createdAt'] ?? '',
      lastModified: map['lastModified'] ?? '',
      fileSize: double.parse(map['fileSize'] ?? '0.0'),
      fileType: map['fileType'] ?? '',
    );
  }
}
