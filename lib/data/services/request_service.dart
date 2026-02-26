import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Create a new service request
  Future<Map<String, dynamic>> createServiceRequest({
    required String serviceType, // This will now be the service_type_id
    required String description,
    required String location,
    required String spaceType,   // This will now be the space_type_id
    int? duration,
    double? areaSqm,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final response = await _client
        .from('service_requests') 
        .insert({
          'user_id': user.id,
          'service_type_id': serviceType,
          'space_type_id': spaceType,
          'location': location,
          'description': description,
          'area_sqm': areaSqm,
          'status': 'Submitted',
        })
        .select()
        .single();

    return response;
  }

  /// Get current user's service requests
  Future<List<Map<String, dynamic>>> getMyRequests() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final response = await _client
        .from('service_requests')
        .select('*, service_types(name)')
        .eq('user_id', user.id) // Updated column name to user_id
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get a specific request by ID
  Future<Map<String, dynamic>> getRequestById(String requestId) async {
    final response = await _client
        .from('service_requests')
        .select('*, profiles(full_name, role), service_types(name)')
        .eq('id', requestId)
        .single();

    return response;
  }

  /// [ADMIN] Get all service requests
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final response = await _client
        .from('service_requests')
        .select('*, profiles(full_name), service_types(name)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// [ADMIN/CUSTOMER] Update request status
  Future<Map<String, dynamic>> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final response = await _client
        .from('service_requests')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId)
        .select()
        .single();

    return response;
  }

  /// Cancel a service request (Soft Delete)
  Future<List<Map<String, dynamic>>> cancelServiceRequest(String requestId) async {
    final response = await _client
        .from('service_requests')
        .update({'status': 'Cancelled'})
        .eq('id', requestId)
        .select();
    
    return List<Map<String, dynamic>>.from(response);
  }
}
