import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_api_test.mocks.dart';
/* TODO: update auth tests issue #10
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late MockFlutterSecureStorage mockStorage;
  late AuthApiService authApiService;

  await dotenv.load(fileName: ".env");
  setUp(() {
    mockClient = MockClient();
    mockStorage = MockFlutterSecureStorage();
    authApiService = AuthApiService(mockClient, mockStorage);
  });

  group('AuthApiService', () {
    final apiUrl = dotenv.env['API_URL'] ?? '';
    const String validAccessToken = 'validAccessToken';
    const String validRefreshToken = 'validRefreshToken';

final userData = {
      'id': "1",
      'email': 'chuck@garden.com',
      'password': 'password',
      'created_at': '2021-08-10T00:00:00.000Z',
      'updated_at': '2021-08-10T00:00:00.000Z',
    };
/*
    final Map<String, dynamic> userData = {
      'id': 1,
      'first_name': 'Test',
      'last_name': 'User',
      'email': 'test@example.com',
      'password': 'password123',
      'created_at': '2021-07-01T00:00:00.000Z',
      'updated_at': '2021-07-01T00:00:00.000Z'
    };*/

    final Map<String, dynamic> validResponseBody = {
      'access_token': validAccessToken,
      'refresh_token': validRefreshToken,
      'user': {'id': 1, 'name': 'Test User', 'email': 'test@example.com'}
    };

    test('createAuthApi should return a User on successful authentication',
        () async {
      final url = Uri.parse(apiUrl + 'auth');
      when(mockClient.post(
        url,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(json.encode(validResponseBody), 200),
      );

      when(mockStorage.write(key: 'accessToken', value: validAccessToken))
          .thenAnswer((_) async => Future.value());
      when(mockStorage.write(key: 'refreshToken', value: validRefreshToken))
          .thenAnswer((_) async => Future.value());

      final user = await authApiService.createAuthApi(userData);

      expect(user, isA<User>());
      expect(user.email, 'test@example.com');
      verify(mockStorage.write(key: 'accessToken', value: validAccessToken))
          .called(1);
      verify(mockStorage.write(key: 'refreshToken', value: validRefreshToken))
          .called(1);
    });

    test('createAuthApi should throw an exception if tokens are missing',
        () async {
      final url = Uri.parse(apiUrl + 'auth');
      when(mockClient.post(
        url,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
            '{"user": {"id": 1, "name": "Test User", "email": "test@example.com"}, "access_token": "validAccessToken", "refresh_token": "validRefreshToken"}',
            200),
      );

      when(mockStorage.write(key: 'accessToken', value: validAccessToken))
          .thenAnswer((_) async => Future.value());
      when(mockStorage.write(key: 'refreshToken', value: validRefreshToken))
          .thenAnswer((_) async => Future.value());

      expect(() async => await authApiService.createAuthApi(userData),
          throwsException);
      verifyNever(
          mockStorage.write(key: 'accessToken', value: validAccessToken));
      verifyNever(
          mockStorage.write(key: 'refreshToken', value: validRefreshToken));
    });

    test('logoutApi should clear storage and return on successful logout',
        () async {
      final url = Uri.parse(apiUrl + 'auth/delete');
      when(mockStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => validAccessToken);
      when(mockClient.delete(
        url,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      when(mockStorage.deleteAll()).thenAnswer((_) async => null);

      await authApiService.logoutApi();

      verify(mockClient.delete(url, headers: anyNamed('headers'))).called(1);
      verify(mockStorage.deleteAll()).called(1);
    });
  });
}*/
