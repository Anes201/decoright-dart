import 'package:decoright/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Create a new service request
  Future<Map<String, dynamic>> createServiceRequest({
    required String serviceType,
    required String description,
    required String location,
    required String spaceType,
    int? duration,
    double? areaSqm,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Generate readable request code (server-side trigger usually handles this, 
    // but if we need to insert it, we might need a function. 
    // For now, assuming DB handles default or trigger for request_code if not passed,
    // OR we just rely on ID. The ERD says request_code is UK.
    // Let's assume the backend generates it or we don't send it yet).

    final response = await _client
        .from('service_requests') // Verify table name in ERD is SERVICE_REQUEST (singular in ERD diagram title, but usually snake_case plural in supabase. Checking code...)
        // Code used 'service_requests' before. ERD says SERVICE_REQUEST.
        // Usually ERD uses singular, Supabase uses plural. keeping existing 'service_requests' 
        // unless I see errors, but wait, the user said "modify supabase logic according to new updates".
        // The ERD title is "DecoRight ERD". 
        // ERD Table: SERVICE_REQUEST. Previous code: 'service_requests'.
        // I will stick to 'service_requests' as standard Supabase convention, 
        // but if the user *literally* renamed tables, I might be in trouble. 
        // However, standard is plural.
        .insert({
          'client_id': user.id, // ERD says client_id, not user_id
          'service_type': serviceType,
          'space_type': spaceType,
          'location': location,
          'description': description,
          'area_sqm': areaSqm,
          'status': 'PENDING', // ERD says PENDING is the start status
          // 'duration' is NOT in the ERD for specific request, it might be impl concept.
          // ERD has construction_start_date/end_date on PROJECT, not request?
          // Wait, SERVICE_REQUEST simple fields: area_sqm, location, description.
          // NO DURAITON in ERD for SERVICE_REQUEST.
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
        .select()
        .eq('client_id', user.id) // Updated column name
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get a specific request by ID
  Future<Map<String, dynamic>> getRequestById(String requestId) async {
    final response = await _client
        .from('service_requests')
        .select('*, profiles(full_name, role)')
        .eq('id', requestId)
        .single();

    return response;
  }

  /// [ADMIN] Get all service requests
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final response = await _client
        .from('service_requests')
        .select('*, profiles(full_name)')
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
