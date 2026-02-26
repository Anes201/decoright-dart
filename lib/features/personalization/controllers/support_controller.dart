import 'package:decoright/data/services/support_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportController extends GetxController {
  static SupportController get instance => Get.find();

  final SupportService _supportService = SupportService();

  final RxMap<String, String> socialLinks = <String, String>{}.obs;
  final RxList<Map<String, dynamic>> faqs = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingLinks = false.obs;
  final RxBool isLoadingFAQs = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSocialLinks();
    fetchFAQs();
  }

  /// Fetch social media links
  Future<void> fetchSocialLinks() async {
    try {
      isLoadingLinks.value = true;
      final links = await _supportService.getSocialLinks();
      socialLinks.assignAll(links);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load support links: $e');
    } finally {
      isLoadingLinks.value = false;
    }
  }

  /// Fetch FAQs
  Future<void> fetchFAQs() async {
    try {
      isLoadingFAQs.value = true;
      final data = await _supportService.getFAQs();
      faqs.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load FAQs: $e');
    } finally {
      isLoadingFAQs.value = false;
    }
  }

  /// Launch URL (WhatsApp, Phone, Social)
  Future<void> launchSupportUrl(String key, String value) async {
    Uri url;
    
    if (key == 'whatsapp') {
      // Clean phone number for whatsapp
      final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
      url = Uri.parse("https://wa.me/$cleanPhone");
    } else if (key == 'phone') {
      url = Uri.parse("tel:$value");
    } else {
      url = Uri.parse(value);
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open $key. Please make sure the app is installed.');
    }
  }
}
