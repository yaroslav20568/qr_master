import 'package:qr_master/models/qr_code_type.dart';

class QrCode {
  final String id;
  final String content;
  final QrCodeType type;
  final DateTime createdAt;
  final String? title;
  final String? description;
  final int scanCount;
  final String? imagePath;

  QrCode({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    this.title,
    this.description,
    this.scanCount = 0,
    this.imagePath,
  });

  QrCode copyWith({
    String? id,
    String? content,
    QrCodeType? type,
    DateTime? createdAt,
    String? title,
    String? description,
    int? scanCount,
    String? imagePath,
  }) {
    return QrCode(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      scanCount: scanCount ?? this.scanCount,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'description': description,
      'scanCount': scanCount,
      'imagePath': imagePath,
    };
  }

  factory QrCode.fromJson(Map<String, dynamic> json) {
    return QrCode(
      id: json['id'] as String,
      content: json['content'] as String,
      type: QrCodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QrCodeType.text,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String?,
      description: json['description'] as String?,
      scanCount: json['scanCount'] as int? ?? 0,
      imagePath: json['imagePath'] as String?,
    );
  }
}
