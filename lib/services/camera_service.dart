import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> imageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    return photo;
  }

  Future<XFile?> videoFromCamera() async {
    final XFile? cameraVideo = await picker.pickVideo(
      source: ImageSource.camera,
    );
    return cameraVideo;
  }
}
