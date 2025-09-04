import 'package:blocsync/blocsync.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template supabase_blocsync_authentication_provider}
/// An authentication provider for Blocsync that uses Supabase Authentication
/// {@endtemplate}
class SupabaseBlocsyncAuthenticationProvider implements AuthenticationProvider {
  /// {@macro supabase_blocsync_authentication_provider}
  SupabaseBlocsyncAuthenticationProvider({
    @visibleForTesting SupabaseClient? supabaseClient,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabaseClient;

  @override
  Future<String?> getToken() async {
    return _supabaseClient.auth.currentSession?.accessToken;
  }
}
