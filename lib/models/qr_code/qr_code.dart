import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/qr_code/qr_code_type.dart';

class QrCode {
  final String id;
  final String content;
  final QrCodeType type;
  final DateTime createdAt;
  final String? title;
  final int scanView;
  final Color color;

  QrCode({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    this.title,
    this.scanView = 0,
    Color? color,
  }) : color = color ?? AppColors.dark;

  QrCode copyWith({
    String? id,
    String? content,
    QrCodeType? type,
    DateTime? createdAt,
    String? title,
    int? scanView,
    Color? color,
  }) {
    return QrCode(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      scanView: scanView ?? this.scanView,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'title': title,
      'scanView': scanView,
      'color': color.toARGB32(),
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
      scanView: json['scanView'] as int? ?? 0,
      color: json['color'] != null
          ? Color(json['color'] as int)
          : AppColors.dark,
    );
  }
}
