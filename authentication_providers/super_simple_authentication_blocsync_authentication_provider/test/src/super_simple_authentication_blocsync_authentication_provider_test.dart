// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:super_simple_authentication_blocsync_authentication_provider/super_simple_authentication_blocsync_authentication_provider.dart';
import 'package:super_simple_authentication_flutter/super_simple_authentication_flutter.dart';

class _MockSuperSimpleAuthentication extends Mock
    implements SuperSimpleAuthentication {}

void main() {
  group('SuperSimpleAuthenticationBlocsyncAuthenticationProvider', () {
    late _MockSuperSimpleAuthentication mockAuthenticationClient;

    setUp(() {
      mockAuthenticationClient = _MockSuperSimpleAuthentication();
    });

    group('constructor', () {
      test('can be instantiated with required authentication client', () {
        expect(
          SuperSimpleAuthenticationBlocsyncAuthenticationProvider(
            authenticationClient: mockAuthenticationClient,
          ),
          isNotNull,
        );
      });
    });

    group('getToken', () {
      test('returns access token when authentication client has token',
          () async {
        // Arrange
        const expectedToken = 'test_access_token_123';
        when(() => mockAuthenticationClient.accessToken)
            .thenReturn(expectedToken);

        final provider =
            SuperSimpleAuthenticationBlocsyncAuthenticationProvider(
          authenticationClient: mockAuthenticationClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, equals(expectedToken));
        verify(() => mockAuthenticationClient.accessToken).called(1);
      });

      test('returns null when authentication client has no token', () async {
        // Arrange
        when(() => mockAuthenticationClient.accessToken).thenReturn(null);

        final provider =
            SuperSimpleAuthenticationBlocsyncAuthenticationProvider(
          authenticationClient: mockAuthenticationClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, isNull);
        verify(() => mockAuthenticationClient.accessToken).called(1);
      });

      test('returns empty string when authentication client has empty token',
          () async {
        // Arrange
        when(() => mockAuthenticationClient.accessToken).thenReturn('');

        final provider =
            SuperSimpleAuthenticationBlocsyncAuthenticationProvider(
          authenticationClient: mockAuthenticationClient,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, equals(''));
        verify(() => mockAuthenticationClient.accessToken).called(1);
      });

      test('returns token when accessToken is called multiple times', () async {
        // Arrange
        const expectedToken = 'test_access_token_456';
        when(() => mockAuthenticationClient.accessToken)
            .thenReturn(expectedToken);

        final provider =
            SuperSimpleAuthenticationBlocsyncAuthenticationProvider(
          authenticationClient: mockAuthenticationClient,
        );

        // Act
        final result1 = await provider.getToken();
        final result2 = await provider.getToken();

        // Assert
        expect(result1, equals(expectedToken));
        expect(result2, equals(expectedToken));
        verify(() => mockAuthenticationClient.accessToken).called(2);
      });
    });
  });
}
