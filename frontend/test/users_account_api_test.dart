import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/apis/custom_exception.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/model/apis/users_account_api.dart';
import 'users_account_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late UsersAccountApiService usersAccountApiService;

  setUp(() {
    mockClient = MockClient();
    usersAccountApiService = UsersAccountApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });
  group('fetch user account by account id', () {
    test("Fetch user accounts should return a list of user accounts", () async {
      final accountId = "5678";
      final userAccounts = [
        UserAccounts(
          id: "1",
          user_id: "1234",
          account_id: "5678",
          createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
          updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
        ),
      ];
      final fetchUri = Uri.parse(apiUrl + 'useraccounts?account_id=$accountId');
      when(mockClient.get(fetchUri)).thenAnswer(
          (_) async => http.Response(jsonEncode(userAccounts), 200));

      final result =
          await usersAccountApiService.fetchUserAccountsApi(accountId);
      for (int i = 0; i < result.length; i++) {
        expect(result[i].id, userAccounts[i].id);
        expect(result[i].user_id, userAccounts[i].user_id);
        expect(result[i].account_id, userAccounts[i].account_id);
        expect(result[i].createdAt, userAccounts[i].createdAt);
        expect(result[i].updatedAt, userAccounts[i].updatedAt);
      }
      verify(mockClient.get(fetchUri));
    });
    test('Fetch user accounts will throw error when status code is 404',
        () async {
      final accountId = "5678";
      final fetchUri =
          Uri.parse(apiUrl + 'useraccounts?account_id=invalid-account');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          () async => await usersAccountApiService
              .fetchUserAccountsApi('invalid-account'),
          throwsA(isA<Exception>()));
      verify(mockClient.get(fetchUri));
    });
    test(
        'Fetch user accounts will throw error if status code is not 200 or 404',
        () async {
      final accountId = "5678";
      final fetchUri = Uri.parse(apiUrl + 'useraccounts?account_id=error');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      expect(
          () async =>
              await usersAccountApiService.fetchUserAccountsApi('error'),
          throwsA(isA<Exception>()));
      verify(mockClient.get(fetchUri));
    });
    test('Throw format exception when response is not JSON', () async {
      final accountId = "5678";
      final fetchUri = Uri.parse(apiUrl + 'useraccounts?account_id=$accountId');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Not Json', 200));
      expect(
          () async =>
              await usersAccountApiService.fetchUserAccountsApi(accountId),
          throwsA(predicate(
              (e) => e is Exception && e.toString().contains('JSON'))));
      verify(mockClient.get(fetchUri));
    });
  });
  group('Fetch user account by userId', () {
    test('Fetch user account should return a user account', () async {
      final userId = "1234";
      final userAccount = UserAccounts(
        id: "1",
        user_id: "1234",
        account_id: "5678",
        createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
        updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      );
      final fetchUri = Uri.parse(apiUrl + 'usersaccount?user_id=$userId');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response(jsonEncode(userAccount), 200));

      final result = await usersAccountApiService.fetchUserAccountApi(userId);
      expect(result.id, userAccount.id);
      expect(result.user_id, userAccount.user_id);
      expect(result.account_id, userAccount.account_id);
      expect(result.createdAt, userAccount.createdAt);
      expect(result.updatedAt, userAccount.updatedAt);
      verify(mockClient.get(fetchUri));
    });
    test('Throw error if status code is 404', () async {
      final userId = "1234";
      final fetchUri = Uri.parse(apiUrl + 'usersaccount?user_id=invalid-user');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          () async =>
              await usersAccountApiService.fetchUserAccountApi('invalid-user'),
          throwsA(isA<Exception>()));
      verify(mockClient.get(fetchUri));
    });
    test('Throw exception if status code is not 200 or 404', () async {
      final userId = "1234";
      final fetchUri = Uri.parse(apiUrl + 'usersaccount?user_id=error');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      expect(
          () async => await usersAccountApiService.fetchUserAccountApi('error'),
          throwsA(isA<Exception>()));
      verify(mockClient.get(fetchUri)).called(1);
    });
    test('Throw format exception when response is not JSON', () async {
      final userId = "1234";
      final fetchUri = Uri.parse(apiUrl + 'usersaccount?user_id=$userId');
      when(mockClient.get(fetchUri))
          .thenAnswer((_) async => http.Response('Not Json', 200));
      expect(
          () async => await usersAccountApiService.fetchUserAccountApi(userId),
          throwsA(predicate(
              (e) => e is Exception && e.toString().contains('JSON'))));
      verify(mockClient.get(fetchUri));
    });
  });
  group('Create user account', () {
    final userAccountData = {
      "user_id": "1234",
      "account_id": "5678",
    };

    final response =
        '{"id": "1", "user_id": "1234", "account_id": "5678", "created_at": "2024-05-23T11:57:57.906107Z", "updated_at": "2024-05-23T11:57:57.906107Z"}';

    final createUri = Uri.parse(apiUrl + 'usersaccount');
    test(
        'Create user account should return with success when status code is 201',
        () async {
      when(mockClient.post(createUri,
              headers: anyNamed('headers'), body: json.encode(userAccountData)))
          .thenAnswer((_) async => http.Response(response, 201));
      await usersAccountApiService.createUserAccountsApi(userAccountData);
      verify(mockClient.post(createUri,
          headers: anyNamed('headers'), body: json.encode(userAccountData)));
    });
    test('Throw exception if failed to create account', () async {
      when(mockClient.post(createUri,
              headers: anyNamed('headers'), body: json.encode(userAccountData)))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      expect(
          () async => await usersAccountApiService
              .createUserAccountsApi(userAccountData),
          throwsA(isA<Exception>()));
      verify(mockClient.post(createUri,
          headers: anyNamed('headers'), body: json.encode(userAccountData)));
    });
  });
}
