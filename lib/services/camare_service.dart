import 'package:image_picker/image_picker.dart';

class CamareService {
  final ImagePicker picker = ImagePicker();

  Future<XFile?> ImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    return photo;
  }

  Future<XFile?> VideoFromCamera() async {
    final XFile? cameraVideo = await picker.pickVideo(
      source: ImageSource.camera,
    );
    return cameraVideo;
  }
}
