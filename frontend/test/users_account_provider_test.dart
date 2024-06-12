import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/users_account.dart';
import 'package:frontend/model/apis/users_account_api.dart';
import 'package:frontend/provider/users_account_provider.dart';
import 'users_account_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, UsersAccountApiService])
void main() {
  late MockUsersAccountApiService mockUsersAccountApiService;
  late UsersAccountsProvider usersAccountsProvider;

  setUp(() {
    mockUsersAccountApiService = MockUsersAccountApiService();
    usersAccountsProvider = UsersAccountsProvider(mockUsersAccountApiService);
  });

  final usersaccount = [
    UserAccounts(
      id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      user_id: '1234',
      account_id: '5678',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    ),
  ];

test('Fetch user accounts should return a list of user accounts', () async {
   when(mockUsersAccountApiService
	   .fetchUserAccountsApi ('5678')).thenAnswer((_) async => usersaccount);
   final result = await usersAccountsProvider.fetchUserAccounts('5678');
   for (int i = 0; i < result.length; i++) {
     expect(result[i].id, usersaccount[i].id);
     expect(result[i].user_id, usersaccount[i].user_id);
     expect(result[i].account_id, usersaccount[i].account_id);
     expect(result[i].createdAt, usersaccount[i].createdAt);
     expect(result[i].updatedAt, usersaccount[i].updatedAt);
   }
   verify(mockUsersAccountApiService
       .fetchUserAccountsApi('5678'));
 });

test('Fetch user account should return a user account', () async {
   when(mockUsersAccountApiService
	   .fetchUserAccountApi ('1234')).thenAnswer((_) async => usersaccount[0]);
   final result = await usersAccountsProvider.fetchUserAccount('1234');
   expect(result.id, usersaccount[0].id);
   expect(result.user_id, usersaccount[0].user_id);
   expect(result.account_id, usersaccount[0].account_id);
   expect(result.createdAt, usersaccount[0].createdAt);
   expect(result.updatedAt, usersaccount[0].updatedAt);
   verify(mockUsersAccountApiService
       .fetchUserAccountApi('1234'));
 });

test('Create user account should return with success when status code is 200',
       () async {
     when(mockUsersAccountApiService.createUserAccountsApi(usersaccount[0].toJson()))
	 .thenAnswer((_) async => usersaccount[0]);
     final result = await usersAccountsProvider.createUserAccounts(usersaccount[0].toJson());
     expect(result.id, usersaccount[0].id);
     expect(result.user_id, usersaccount[0].user_id);
     expect(result.account_id, usersaccount[0].account_id);
     expect(result.createdAt, usersaccount[0].createdAt);
     expect(result.updatedAt, usersaccount[0].updatedAt);
     verify(mockUsersAccountApiService.createUserAccountsApi(usersaccount[0].toJson()));
   });
}

