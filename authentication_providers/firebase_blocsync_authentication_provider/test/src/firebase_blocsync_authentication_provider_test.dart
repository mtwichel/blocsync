// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_blocsync_authentication_provider/firebase_blocsync_authentication_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  group('FirebaseBlocsyncAuthenticationProvider', () {
    late _MockFirebaseAuth mockFirebaseAuth;
    late _MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = _MockFirebaseAuth();
      mockUser = _MockUser();
    });

    group('constructor', () {
      test('can be instantiated with injected FirebaseAuth', () {
        expect(
          FirebaseBlocsyncAuthenticationProvider(
              firebaseAuth: mockFirebaseAuth),
          isNotNull,
        );
      });
    });

    group('getToken', () {
      test('returns token when user is authenticated', () async {
        // Arrange
        const expectedToken = 'test_token_123';
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.getIdToken())
            .thenAnswer((_) async => expectedToken);

        final provider = FirebaseBlocsyncAuthenticationProvider(
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, equals(expectedToken));
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockUser.getIdToken()).called(1);
      });

      test('returns null when no user is authenticated', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final provider = FirebaseBlocsyncAuthenticationProvider(
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, isNull);
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verifyNever(() => mockUser.getIdToken());
      });

      test('throws exception when getIdToken throws exception', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.getIdToken()).thenThrow(Exception('Token error'));

        final provider = FirebaseBlocsyncAuthenticationProvider(
          firebaseAuth: mockFirebaseAuth,
        );

        // Act & Assert
        expect(
          provider.getToken,
          throwsA(isA<Exception>()),
        );
      });

      test('returns null when getIdToken returns null', () async {
        // Arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.getIdToken()).thenAnswer((_) async => null);

        final provider = FirebaseBlocsyncAuthenticationProvider(
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        final result = await provider.getToken();

        // Assert
        expect(result, isNull);
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockUser.getIdToken()).called(1);
      });
    });
  });
}
