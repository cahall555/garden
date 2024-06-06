import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user.dart';
import 'package:frontend/model/apis/user_api.dart';
import 'package:frontend/provider/user_provider.dart';
import 'user_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, UserApiService])
void main() {
  late MockUserApiService mockUserApiService;
  late UserProvider userProvider;

  setUp(() {
    mockUserApiService = MockUserApiService();
    userProvider = UserProvider(mockUserApiService);
  });

  final createUser = User(
    id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@garden.com',
    password: 'password',
    passwordConfirmation: 'password',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );

  test('Create user should return with success when status code is 200',
      () async {
    when(mockUserApiService.createUserApi(createUser.toJson()))
        .thenAnswer((_) async => createUser);
	await userProvider.createUser(createUser.toJson());
    verify(mockUserApiService.createUserApi(createUser.toJson()));
  });

}
