import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/view/auth_login.dart';
import 'package:frontend/view/garden_list.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:frontend/model/apis/users_account_api.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/users_account_provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockUsersAccountsProvider extends Mock implements UsersAccountsProvider {}

void main() {
  group('AuthCreate Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockUsersAccountsProvider mockUsersAccountsProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockUsersAccountsProvider = MockUsersAccountsProvider();
    });

    Widget createWidgetUnderTest() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<UsersAccountsProvider>.value(
              value: mockUsersAccountsProvider),
        ],
        child: MaterialApp(
          home: AuthCreate(),
        ),
      );
    }

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
    final usersaccount = UserAccounts(
      id: 'b5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      user_id: '1234',
      account_id: '5678',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('User Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('shows error message when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('calls userLogin when fields are filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      var emailField = find.byType(TextField).at(0);
      var passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'chuck@garden.com');
      await tester.enterText(passwordField, 'password');
      await tester.tap(find.text('Login'));
      await tester.pump();
    });

    testWidgets('navigates to GardenList on successful login',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      var emailField = find.byType(TextField).at(0);
      var passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'chuck@garden.com');
      await tester.enterText(passwordField, 'password');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

//      expect(find.byType(GardenList), findsOneWidget); TODO: add mocking
    });
  });
}
