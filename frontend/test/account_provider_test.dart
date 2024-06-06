import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/account.dart';
import 'package:frontend/model/apis/account_api.dart';
import 'package:frontend/provider/account_provider.dart';
import 'account_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, AccountApiService])
void main() {
  late MockAccountApiService mockAccountApiService;
  late AccountProvider accountProvider;

  setUp(() {
    mockAccountApiService = MockAccountApiService();
    accountProvider = AccountProvider(mockAccountApiService);
  });

  final accounts = [
    Account(
      id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      plan: 'Free',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    ),
  ];

  final createAccount = Account(
    id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    plan: 'Basic',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );

  test('Create account should return with success when status code is 200',
      () async {
    when(mockAccountApiService.createAccountApi(createAccount.toJson()))
        .thenAnswer((_) async => accounts[0]);
    final result = await accountProvider.createAccount(createAccount.toJson());
    expect(result.id, accounts[0].id);
    expect(result.plan, accounts[0].plan);
    expect(result.createdAt, accounts[0].createdAt);
    expect(result.updatedAt, accounts[0].updatedAt);
    verify(mockAccountApiService.createAccountApi(createAccount.toJson()));
  });

  test('Delete account should return with success when status code is 200',
      () async {
    when(mockAccountApiService
            .deleteAccountApi('b5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
        .thenAnswer((_) async => null);
    await accountProvider
        .deleteAccount('b5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    verify(mockAccountApiService
        .deleteAccountApi('b5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
  });
}
