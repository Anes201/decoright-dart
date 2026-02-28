import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceTypeService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Get all active service types
  Future<List<Map<String, dynamic>>> getServiceTypes() async {
    try {
      final response = await _client
          .from('service_types')
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }
}
