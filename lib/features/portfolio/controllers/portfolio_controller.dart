import 'package:decoright/data/services/portfolio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  final PortfolioService _portfolioService = PortfolioService();

  final isLoading = false.obs;
  final projects = <Map<String, dynamic>>[].obs;
  final galleryItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    isLoading.value = true;
    await Future.wait([
      loadProjects(),
      loadGalleryItems(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadProjects() async {
    try {
      final items = await _portfolioService.getProjects();
      projects.value = items;
    } catch (e) {
      print('Error loading projects: $e');
    }
  }

  Future<void> loadGalleryItems() async {
    try {
      final items = await _portfolioService.getGalleryItems();
      galleryItems.value = items;
    } catch (e) {
      print('Error loading gallery items: $e');
    }
  }

  // Backward compatibility/Legacy call if needed
  Future<void> loadPortfolio() => loadAll();
}
