import 'package:flutter/material.dart';
import 'package:qr_master/models/qr_code/qr_code_type.dart';

enum ScanHistoryAction { scanned, created, shared }

class ScanHistoryItem {
  final String id;
  final String content;
  final QrCodeType type;
  final ScanHistoryAction action;
  final DateTime timestamp;
  final String? title;
  final Color? color;

  ScanHistoryItem({
    required this.id,
    required this.content,
    required this.type,
    required this.action,
    required this.timestamp,
    this.title,
    this.color,
  });

  ScanHistoryItem copyWith({
    String? id,
    String? content,
    QrCodeType? type,
    ScanHistoryAction? action,
    DateTime? timestamp,
    String? title,
    Color? color,
  }) {
    return ScanHistoryItem(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'action': action.name,
      'timestamp': timestamp.toIso8601String(),
      'title': title,
      if (color != null) 'color': color!.toARGB32(),
    };
  }

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      id: json['id'] as String,
      content: json['content'] as String,
      type: QrCodeType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QrCodeType.text,
      ),
      action: ScanHistoryAction.values.firstWhere(
        (e) => e.name == json['action'],
        orElse: () => ScanHistoryAction.scanned,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      title: json['title'] as String?,
      color: json['color'] != null ? Color(json['color'] as int) : null,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
