import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/apis/user_api.dart';
import 'user_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late UserApiService userApiService;

  setUp(() {
    mockClient = MockClient();
    userApiService = UserApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  final user = {
    "firstName": 'John',
    "lastName": 'Doe',
    "email": 'john@garden.com',
    "password": 'password',
    "passwordConfirmation": 'password',
  };
  final response =
      '{"id": "123", "fristName": "John", "lastName": "Doe", "email": "john@garden.com", "password": "password", "passwordConfirmation": "password", "createdAt": "2024-05-23T11:57:57.906107Z", "updatedAt": "2024-05-23T11:57:57.906107Z"}';

  final createUri = Uri.parse(apiUrl + 'users');

  test('Create user should return with success when status code is 201',
      () async {
    when(mockClient.post(createUri,
            body: json.encode(user), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(response, 201));
    await userApiService.createUserApi(user);
    verify(mockClient.post(createUri,
        body: json.encode(user), headers: anyNamed('headers')));
  });

  final sqlinjectionUri = Uri.parse(apiUrl + 'users');

  test('SQL injection should return error when status code is 400', () async {
    when(mockClient.post(sqlinjectionUri, body: anyNamed('body'), headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response('Error', 400));
    expect(
      () async => await userApiService.createUserApi({'query': '\'OR\'1\'=\'1'}),
      throwsA(isA<Exception>()),
    );
    verify(mockClient.post(sqlinjectionUri, headers: anyNamed('headers'), body: anyNamed('body')));
  });
	

}
