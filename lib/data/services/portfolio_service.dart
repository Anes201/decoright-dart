import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class PortfolioService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Get all portfolio items
  Future<List<Map<String, dynamic>>> getPortfolioItems() async {
    final response = await _client
        .from('projects') // Updated table name
        .select()
        .eq('visibility', 'PUBLIC') // Assuming only public by default
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// [ADMIN] Upload a new portfolio item (Project)
  Future<Map<String, dynamic>> uploadPortfolioItem({
    required String title,
    required String description,
    required File file,
    required String mediaType,
    bool isPublicGuest = true, // Maps to visibility
  }) async {
    // 1. Upload file to storage
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    
    await _client.storage
        .from('portfolio-media') // Bucket name might need verification but assuming same
        .upload(fileName, file);

    // Get public URL
    final publicUrl = _client.storage
        .from('portfolio-media')
        .getPublicUrl(fileName);

    // 2. Insert into PROJECTS table
    final projectResponse = await _client
        .from('projects')
        .insert({
          'title': title,
          'description': description,
          'main_image_url': publicUrl,
          // Defaults for new required fields or map them if UI supports it later
          'service_type': 'INTERIOR_DESIGN', // Default
          'space_type': 'HOUSES_AND_ROOMS', // Default
          'visibility': isPublicGuest ? 'PUBLIC' : 'AUTHENTICATED_ONLY',
        })
        .select()
        .single();

    // 3. Insert into PROJECT_IMAGE (optional but good for gallery consistency)
    final projectId = projectResponse['id'];
    await _client.from('project_images').insert({
        'project_id': projectId,
        'image_url': publicUrl,
        'is_cover': true,
        'sort_order': 0,
        'uploaded_at': DateTime.now().toIso8601String(),
    });

    return projectResponse;
  }
}
