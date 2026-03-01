import 'package:decoright/data/services/space_types_service.dart';
import 'package:get/get.dart';

class SpaceTypesController extends GetxController {
  final SpaceTypesService _service = SpaceTypesService();

  final isLoading = false.obs;
  final spaceTypes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSpaceTypes();
  }

  Future<void> loadSpaceTypes() async {
    try {
      isLoading.value = true;
      final items = await _service.getSpaceTypes();
      spaceTypes.value = items;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load space types: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
