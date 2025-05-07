import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker picker = ImagePicker();
  bool isPicking = false; // Variable para controlar el estado

  Future<List<XFile>?> imageFromGallery() async {
    if (isPicking) return null; // Si ya está en uso, no ejecutar de nuevo
    isPicking = true;

    try {
      final List<XFile> image = await picker.pickMultiImage();
      return image;
    } catch (e) {
      print("Error al seleccionar imágenes: $e");
      return null;
    } finally {
      isPicking = false;
    }
  }

  Future<XFile?> videoFromGallery() async {
    if (isPicking) return null;
    isPicking = true;

    try {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 2),
      );
      return video;
    } catch (e) {
      print("Error al seleccionar video: $e");
      return null;
    } finally {
      isPicking = false;
    }
  }
}
