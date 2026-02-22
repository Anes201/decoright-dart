import 'package:decoright/data/services/portfolio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  final PortfolioService _portfolioService = PortfolioService();

  final isLoading = false.obs;
  final portfolioItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();
  }

  Future<void> loadPortfolio() async {
    try {
      isLoading.value = true;
      final items = await _portfolioService.getPortfolioItems();
      portfolioItems.value = items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load portfolio: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
