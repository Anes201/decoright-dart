import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/utils/helpers/network_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpaceTypesService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Map<String, dynamic>>> getSpaceTypes() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return [];

      final response = await _client
          .from('space_types')
          .select('id, name, display_name_en, display_name_ar, display_name_fr, description, space_type_images(*)')
          .eq('is_active', true)
          .order('name', ascending: true);
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching space types: $e');
      return [];
    }
  }
}
