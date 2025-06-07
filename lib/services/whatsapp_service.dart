import 'package:url_launcher/url_launcher.dart';

class WhatsappService {
  static Future<bool> openWhatsApp(String phone, {String message = ''}) async {
    final Uri url = Uri.parse('https://wa.me/$phone?text=$message');
    if (!await launchUrl(url)) {
      return false;
    }
    return true;
  }
}
