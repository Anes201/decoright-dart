import 'package:decoright/data/services/portfolio_service.dart';
import 'package:decoright/features/authentication/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PortfolioController extends GetxController {
  final PortfolioService _portfolioService = PortfolioService();

  final isLoading = false.obs;
  final projects = <Map<String, dynamic>>[].obs;
  final galleryItems = <Map<String, dynamic>>[].obs;
  
  // Cache for project images: { projectId: [image1, image2, ...] }
  final projectImages = <String, List<Map<String, dynamic>>>{}.obs;
  final imagesLoading = <String, bool>{}.obs;

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
      final authController = AuthController.instance;
      // Check if user is logged in (not a guest and has a user object)
      final isAuthenticated = !authController.isGuest.value && 
                              Supabase.instance.client.auth.currentSession != null;
      
      final items = await _portfolioService.getProjects(isAuthenticated: isAuthenticated);
      projects.value = items;
    } catch (e) {
      print('Error loading projects: $e');
    }
  }

  Future<void> loadProjectImages(String projectId) async {
    if (projectImages.containsKey(projectId)) return; // Already loaded

    try {
      imagesLoading[projectId] = true;
      final images = await _portfolioService.getProjectImages(projectId);
      projectImages[projectId] = images;
    } catch (e) {
      print('Error loading project images for $projectId: $e');
    } finally {
      imagesLoading[projectId] = false;
    }
  }


  Future<void> loadGalleryItems() async {
    try {
      final authController = AuthController.instance;
      final isAuthenticated = !authController.isGuest.value && 
                              Supabase.instance.client.auth.currentSession != null;
                              
      final items = await _portfolioService.getGalleryItems(isAuthenticated: isAuthenticated);
      galleryItems.value = items;
    } catch (e) {
      print('Error loading gallery items: $e');
    }
  }


  // Backward compatibility/Legacy call if needed
  Future<void> loadPortfolio() => loadAll();
}
