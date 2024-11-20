import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:frontend/model/apis/user_api.dart';
import 'package:frontend/view/auth_login.dart';
import 'package:frontend/view/user_create.dart';
import 'package:frontend/view/auth_landing.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/provider/auth_provider.dart';
// TODO: update auth tests issue #10
void main() {
  testWidgets('LandingPage has Register and Login buttons', (WidgetTester tester) async {
	  final client = http.Client(); 
	  final authApiService = AuthApiService(client);
	  final userApiService = UserApiService(client);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(authApiService: authApiService)),
	  ChangeNotifierProvider(create: (_) => UserProvider(userApiService)),
        ],
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );

    expect(find.text('Register'), findsOneWidget);

    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle(); 

    expect(find.byType(UserCreate), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); 

    expect(find.byType(AuthCreate), findsOneWidget);
  });
}
