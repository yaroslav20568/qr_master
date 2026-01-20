import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/qr_code_type.dart';

class QrService {
  Future<Uint8List?> generateQrCodeImage({
    required String data,
    required int size,
    Color? foregroundColor,
    Color? backgroundColor,
    String? embeddedImagePath,
  }) async {
    try {
      final painter = QrPainter(
        data: data,
        version: QrVersions.auto,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: foregroundColor ?? AppColors.dark,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor ?? AppColors.dark,
        ),
      );

      final picRecorder = ui.PictureRecorder();
      final canvas = Canvas(picRecorder);
      final canvasSize = Size(size.toDouble(), size.toDouble());
      painter.paint(canvas, canvasSize);

      final picture = picRecorder.endRecording();
      final image = await picture.toImage(
        canvasSize.width.toInt(),
        canvasSize.height.toInt(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  QrCodeType detectQrCodeType(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return QrCodeType.url;
    } else if (content.startsWith('WIFI:')) {
      return QrCodeType.wifi;
    } else if (content.startsWith('BEGIN:VCARD')) {
      return QrCodeType.contact;
    } else {
      return QrCodeType.text;
    }
  }
}
