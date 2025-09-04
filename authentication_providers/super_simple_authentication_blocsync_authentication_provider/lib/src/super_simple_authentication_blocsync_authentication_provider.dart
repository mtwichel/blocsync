import 'package:blocsync/blocsync.dart';
import 'package:super_simple_authentication_flutter/super_simple_authentication_flutter.dart';

/// {@template super_simple_authentication_blocsync_authentication_provider}
/// An authentication provider for Blocsync that uses Super Simple Authentication
/// {@endtemplate}
class SuperSimpleAuthenticationBlocsyncAuthenticationProvider
    implements AuthenticationProvider {
  /// {@macro super_simple_authentication_blocsync_authentication_provider}
  SuperSimpleAuthenticationBlocsyncAuthenticationProvider({
    required SuperSimpleAuthentication authenticationClient,
  }) : _authenticationClient = authenticationClient;

  final SuperSimpleAuthentication _authenticationClient;

  @override
  Future<String?> getToken() async {
    return _authenticationClient.accessToken;
  }
}
