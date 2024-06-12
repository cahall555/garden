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

  test('login should return with success when status code is 200', () async {
    when(mockAuthApiService.createAuthApi(createUser.toJson()))
	.thenAnswer((_) async => createUser);
    await authProvider.login(createUser.toJson());

      expect(authProvider.authUser?.id, createUser.id);

    verify(mockAuthApiService.createAuthApi(createUser.toJson()));

  });

  test('logout should return with success when status code is 200', () async {
    when(mockAuthApiService.logoutApi())
	.thenAnswer((_) async => createUser);
    await authProvider.logout();

    verify(mockAuthApiService.logoutApi());
  });

}


