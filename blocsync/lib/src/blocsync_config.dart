import 'package:blocsync/blocsync.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class BlocSyncConfig {
  static ApiClient? _apiClient;
  static AuthenticationProvider? _authenticationProvider;

  static set apiClient(ApiClient? apiClient) => _apiClient = apiClient;

  static ApiClient get apiClient {
    if (_apiClient == null) throw Exception('API client not found');
    return _apiClient!;
  }

  static set storage(Storage? storage) => HydratedBloc.storage = storage;

  static Storage get storage => HydratedBloc.storage;

  static set authenticationProvider(
          AuthenticationProvider? authenticationProvider) =>
      _authenticationProvider = authenticationProvider;

  static AuthenticationProvider get authenticationProvider {
    if (_authenticationProvider == null)
      throw Exception('Authentication provider not found');
    return _authenticationProvider!;
  }
}
