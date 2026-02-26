import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';

class SupportService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Fetch social links from site_settings
  Future<Map<String, String>> getSocialLinks() async {
    try {
      final List<dynamic> response = await _client
          .from('site_settings')
          .select('key, value')
          .filter('key', 'in', '("whatsapp", "phone", "facebook", "instagram", "twitter", "linkedin")');
      
      final Map<String, String> links = {};
      for (var item in response) {
        if (item['value'] != null && item['value'].toString().isNotEmpty) {
          links[item['key']] = item['value'];
        }
      }
      return links;
    } catch (e) {
      throw Exception('Failed to fetch social links: $e');
    }
  }

  /// Fetch all active FAQs
  Future<List<Map<String, dynamic>>> getFAQs() async {
    try {
      final response = await _client
          .from('faqs')
          .select('*')
          .eq('is_active', true)
          .order('display_order', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch FAQs: $e');
    }
  }
}
