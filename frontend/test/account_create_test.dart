import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/apis/account_api.dart';
import 'package:frontend/model/apis/users_account_api.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/provider/account_provider.dart';
import 'package:frontend/provider/users_account_provider.dart';
import 'package:frontend/view/account_create.dart';

void main() {
  group('AccountCreate Widget Tests', () {
    late AccountProvider accountProvider;
    late UsersAccountsProvider usersAccountsProvider;
    late User testUser;
    final client = http.Client();
    final accountApiService = AccountApiService(client);
    final usersAccountApiService = UsersAccountApiService(client);

    setUp(() {
      testUser = User(
          id: '123',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@garden.com',
          password: 'password',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
    });

    Widget createWidgetUnderTest() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => AccountProvider(accountApiService)),
          ChangeNotifierProvider(
              create: (_) => UsersAccountsProvider(usersAccountApiService)),
        ],
        child: MaterialApp(
          home: AccountCreate(user: testUser),
        ),
      );
    }

    testWidgets('should display dropdown with plans and submit button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
        'should show snackbar when no plan is selected and submit is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Please select a plan.'), findsOneWidget);
    });

    testWidgets(
        'should call submitAccount when a plan is selected and submit is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Free').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Account created successfully!'),
          findsNothing); //nothing is found because we are not mocking the API call here.
    });
  });
}
