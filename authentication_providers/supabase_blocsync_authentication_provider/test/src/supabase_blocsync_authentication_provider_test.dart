// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_blocsync_authentication_provider/supabase_blocsync_authentication_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockSession extends Mock implements Session {}

void main() {
  group('SupabaseBlocsyncAuthenticationProvider', () {
    late _MockSupabaseClient mockSupabaseClient;
    late _MockGoTrueClient mockAuth;
    late _MockSession mockSession;

    setUp(() {
      mockSupabaseClient = _MockSupabaseClient();
      mockAuth = _MockGoTrueClient();
      mockSession = _MockSession();
    });

    group('constructor', () {
      test('can be instantiated with injected SupabaseClient', () {
        expect(
          SupabaseBlocsyncAuthenticationProvider(
              supabaseClient: mockSupabaseClient),
          isNotNull,
        );
      });
    });

    group('getToken', () {
      test('returns access token when session exists', () async {
        // Arrange
        const expectedToken = 'test_access_token_123';
        when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
        when(() => mockAuth.currentSession).thenReturn(mockSession);
        when(() => mockSession.accessToken).thenReturn(expectedToken);

        final provider = SupabaseBlocsyncAuthenticationProvider(
          supabaseClient: mockSupabaseClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, equals(expectedToken));
        verify(() => mockSupabaseClient.auth).called(1);
        verify(() => mockAuth.currentSession).called(1);
        verify(() => mockSession.accessToken).called(1);
      });

      test('returns null when no session exists', () async {
        // Arrange
        when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
        when(() => mockAuth.currentSession).thenReturn(null);

        final provider = SupabaseBlocsyncAuthenticationProvider(
          supabaseClient: mockSupabaseClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, isNull);
        verify(() => mockSupabaseClient.auth).called(1);
        verify(() => mockAuth.currentSession).called(1);
        verifyNever(() => mockSession.accessToken);
      });

      test('returns empty string when session has empty access token',
          () async {
        // Arrange
        when(() => mockSupabaseClient.auth).thenReturn(mockAuth);
        when(() => mockAuth.currentSession).thenReturn(mockSession);
        when(() => mockSession.accessToken).thenReturn('');

        final provider = SupabaseBlocsyncAuthenticationProvider(
          supabaseClient: mockSupabaseClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, equals(''));
        verify(() => mockSupabaseClient.auth).called(1);
        verify(() => mockAuth.currentSession).called(1);
        verify(() => mockSession.accessToken).called(1);
      });
    });
  });
}
