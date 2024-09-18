import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:frontend/model/account.dart';
import 'package:frontend/model/apis/account_api.dart';
import 'package:frontend/model/apis/custom_exception.dart';
import 'account_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late AccountApiService accountApiService;

  setUp(() {
    mockClient = MockClient();
    accountApiService = AccountApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  final uri =
      Uri.parse(apiUrl + 'accounts/5d34bbee-7fc2-4e59-a513-8b26245d5abf');
  const jsonString = """

[{"id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","plan":"Basic", "created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]

  """;

  final expectedAccounts = (json.decode(jsonString) as List)
      .map((data) => Account.fromJson(data))
      .toList();

  test('should return a list of accounts with success when status code is 200',
      () async {
    when(mockClient.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await accountApiService
        .fetchAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedAccounts[i].id);
      expect(result[i].plan, expectedAccounts[i].plan);
      expect(result[i].createdAt, expectedAccounts[i].createdAt);
      expect(result[i].updatedAt, expectedAccounts[i].updatedAt);
    }
    verify(mockClient.get(uri, headers: anyNamed('headers')));
  });

  test("should return 404 on failure", () async {
    when(mockClient.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 404));
    await accountApiService
        .fetchAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    verify(mockClient.get(uri, headers: anyNamed('headers')));
  });

  test("should throw http exception when failed to fetch data", () async {
    when(mockClient.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(
        accountApiService
            .fetchAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'),
        throwsException);
    verify(mockClient.get(uri, headers: anyNamed('headers')));
  });

  test("if data is a map return data", () async {
    final data = {
      'id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      'plan': 'Basic',
      'created_at': '2024-05-23T11:57:57.906107Z',
      'updated_at': '2024-05-23T11:57:57.906107Z'
    };
    when(mockClient.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(json.encode(data), 200));
    final account = await accountApiService
        .fetchAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    expect(account, isA<List<Account>>());
    expect(account.length, 1);
    expect(account.first.id, "5d34bbee-7fc2-4e59-a513-8b26245d5abf");
  });

  test("expected list or map but got runtime type, malformed data", () async {
    when(mockClient.get(uri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('"malformed data"', 200));
    expectLater(
        () async => await accountApiService
            .fetchAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Expected a list or a map but got'))));
    verify(mockClient.get(uri, headers: anyNamed('headers')));
  });

  final createUri = Uri.parse(apiUrl + 'accounts');
  final accountData = {
    "plan": "Basic",
  };
  final response = '{"id": "123", "plan": "Basic"}';

  test("should create account and return 201 on success", () async {
    when(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(accountData)))
        .thenAnswer((_) async => http.Response(response, 201));
    await accountApiService.createAccountApi(accountData);
    verify(mockClient.post(createUri,
        headers: anyNamed('headers'), body: json.encode(accountData)));
  });

  test("should throw exception on failure to create account", () async {
    when(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(accountData)))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(accountApiService.createAccountApi(accountData), throwsException);
    verify(mockClient.post(createUri,
        headers: anyNamed('headers'), body: json.encode(accountData)));
  });

  final deleteUri =
      Uri.parse(apiUrl + 'accounts/5d34bbee-7fc2-4e59-a513-8b26245d5abf');
  test("should delete account with success code 200", () async {
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "success"}', 200));
    await accountApiService
        .deleteAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
  });

  test("should throw exception on failure to delete account", () async {
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(
        accountApiService
            .deleteAccountApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'),
        throwsException);
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
  });

  final sqlInjectionUri = Uri.parse(apiUrl +
      'accounts/5d34bbee-7fc2-4e59-a513-8b26245d5abf\' OR \'1\' = \'1');
  test("should return 404 on sql injection", () async {
    when(mockClient.get(sqlInjectionUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 404));
    await accountApiService.fetchAccountApi(
        '5d34bbee-7fc2-4e59-a513-8b26245d5abf\' OR \'1\' = \'1');
    verify(mockClient.get(sqlInjectionUri, headers: anyNamed('headers')));
  });
}
