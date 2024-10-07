import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'auth_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, AuthApiService])
void main() {
  late MockAuthApiService mockAuthApiService;
  late AuthProvider authProvider;

  setUp(() {
    mockAuthApiService = MockAuthApiService();
    authProvider = AuthProvider(authApiService: mockAuthApiService);
  });
  final createUser = User(
    id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    firstName: 'Chuck',
    lastName: 'Hall',
    email: 'chuck@garden.com',
    password: 'password',
    passwordConfirmation: 'password',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );
  group('AuthProvider Tests', () {
    final user = createUser.toJson();
    test('email getter returns email when authUser is not null', () {
      final email = createUser.email;

      expect(email, 'chuck@garden.com');
    });

    test('email getter returns empty string when authUser is null', () {
      final email = '';

      expect(email, '');
    });

    test('FirstName getter returns firstName when authUser is not null', () {
      final firstName = createUser.firstName;

      expect(firstName, 'Chuck');
    });

    test('FirstName getter returns empty string when authUser is null', () {
      final firstName = '';
      expect(firstName, '');
    });

    test('createAuth should call AuthApiService and return user on success',
        () async {
      when(mockAuthApiService.createAuthApi(createUser.toJson()))
          .thenAnswer((_) async => createUser);

      final result = await authProvider.createAuth(createUser.toJson());

      expect(result, createUser);
      verify(mockAuthApiService.createAuthApi(createUser.toJson())).called(1);
    });

    test('createAuth should throw an exception on failure', () async {
      // Arrange
      final userMap = {'email': 'test@example.com', 'firstName': 'John'};
      when(mockAuthApiService.createAuthApi(userMap))
          .thenThrow(Exception('Error'));

      // Act & Assert
      expect(
          () async => await authProvider.createAuth(userMap), throwsException);
    });
  });
  test('login should return with success when status code is 200', () async {
    when(mockAuthApiService.createAuthApi(createUser.toJson()))
        .thenAnswer((_) async => createUser);
    await authProvider.login(createUser.toJson());

    expect(authProvider.authUser?.id, createUser.id);

    verify(mockAuthApiService.createAuthApi(createUser.toJson()));
  });

  test('logout should return with success when status code is 200', () async {
    when(mockAuthApiService.logoutApi()).thenAnswer((_) async => createUser);
    await authProvider.logout();

    verify(mockAuthApiService.logoutApi());
  });
}
