import 'package:image_picker/image_picker.dart';
import 'package:qr_master/services/logger_service.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      LoggerService.info('Picking image from gallery');
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      LoggerService.info('Image picked successfully: ${image?.path}');
      return image;
    } catch (e, st) {
      LoggerService.error(
        'Error picking image from gallery',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<XFile?> pickImageFromCamera() async {
    try {
      LoggerService.info('Picking image from camera');
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      LoggerService.info('Image picked successfully: ${image?.path}');
      return image;
    } catch (e, st) {
      LoggerService.error(
        'Error picking image from camera',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
