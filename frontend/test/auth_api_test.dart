import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'auth_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late AuthApiService authApiService;

  setUp(() {
    mockClient = MockClient();
    authApiService = AuthApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  test('loginApi returns a User if the http call completes successfully',
      () async {
    final userData = {
      'id': "1",
      'email': 'chuck@garden.com',
      'password': 'password',
      'created_at': '2021-08-10T00:00:00.000Z',
      'updated_at': '2021-08-10T00:00:00.000Z',
    };

   final response = '{"id": "1", "email": "chuck@garden.com", "password": "password", "created_at": "2021-08-10T00:00:00.000Z", "updated_at": "2021-08-10T00:00:00.000Z"}';

    when(mockClient.post(Uri.parse(apiUrl + 'auth'),
	    headers: {"Content-Type": "application/json"},
	    body: json.encode(userData)))
	.thenAnswer((_) async =>
	    http.Response(response, 200));
    
    final user = await authApiService.createAuthApi(userData);

    expect(user.id, '1');
  });

  test('logoutApi returns void if the http call completes successfully',
      () async {
    final response = '{"message": "Logout successful"}';

    when(mockClient.delete(Uri.parse(apiUrl + 'auth/delete'),
	    headers: {"Content-Type": "application/json"}))
	.thenAnswer((_) async => http.Response(response, 200));

    await authApiService.logoutApi();
  });
}
