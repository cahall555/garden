import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
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
    when(mockClient.get(fetchUri))
        .thenAnswer((_) async => http.Response(jsonEncode(userAccounts), 200));

    final result = await usersAccountApiService.fetchUserAccountsApi(accountId);
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, userAccounts[i].id);
      expect(result[i].user_id, userAccounts[i].user_id);
      expect(result[i].account_id, userAccounts[i].account_id);
      expect(result[i].createdAt, userAccounts[i].createdAt);
      expect(result[i].updatedAt, userAccounts[i].updatedAt);
    }
    verify(mockClient.get(fetchUri));
  });

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

  final userAccountData = {"user_id": "1234", "account_id": "5678",};

  final response =
      '{"id": "1", "user_id": "1234", "account_id": "5678", "created_at": "2024-05-23T11:57:57.906107Z", "updated_at": "2024-05-23T11:57:57.906107Z"}';

  final createUri = Uri.parse(apiUrl + 'usersaccount');
  test('Create user account should return with success when status code is 201',
      () async {
   
    when(mockClient.post(createUri,
	    headers: anyNamed('headers'), body: json.encode(userAccountData)))
	.thenAnswer((_) async => http.Response(response, 201));
    await usersAccountApiService.createUserAccountsApi(userAccountData);
    verify(mockClient.post(createUri,
	headers: anyNamed('headers'), body: json.encode(userAccountData)));

  });

  }
