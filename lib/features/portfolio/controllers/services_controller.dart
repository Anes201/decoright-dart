import 'package:decoright/data/services/service_type_service.dart';
import 'package:get/get.dart';

class ServicesController extends GetxController {
  final ServiceTypeService _service = ServiceTypeService();

  final isLoading = false.obs;
  final services = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      isLoading.value = true;
      final items = await _service.getServiceTypes();
      services.value = items;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
