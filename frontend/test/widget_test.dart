import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:frontend/view/tag_detail.dart';
import 'package:frontend/model/tag.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/apis/tag_api.dart';
import 'package:frontend/provider/tag_provider.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/view/plant_detail.dart';
import 'package:frontend/view/auth_landing.dart';
import 'package:frontend/model/plant.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockTagApiService extends Mock implements TagApiService {}

class MockAuthApiService extends Mock implements AuthApiService {}
void main() {
  group('Main App Tests', () {
    late MockHttpClient mockHttpClient;
    late MockTagApiService mockTagApiService;
    late MockAuthApiService mockAuthApiService;

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockTagApiService = MockTagApiService();
      mockAuthApiService = MockAuthApiService();
    });
    testWidgets('MyApp should render home screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => TagProvider(mockTagApiService)),
            ChangeNotifierProvider<AuthProvider>(
                create: (_) => AuthProvider(authApiService: mockAuthApiService)),
          ],
          child: MyApp(tagApiService: mockTagApiService),
        ),
      );
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
