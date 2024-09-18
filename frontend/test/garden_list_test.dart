import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/view/auth_landing.dart';
import 'package:frontend/view/tags_list.dart';
import 'package:frontend/view/garden_list.dart';
import 'package:frontend/view/garden_create.dart';
import 'package:frontend/components/garden_card.dart';
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/account.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/model/apis/auth_api.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'package:frontend/provider/users_account_provider.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockGardenApiService extends Mock implements GardenApiService {}

class MockAuthApiService extends Mock implements AuthApiService {}

void main() {
  testWidgets('GardenList Widget Test', (WidgetTester tester) async {
    final mockGardenApiService = MockGardenApiService();
    final mockAuthApiService = MockAuthApiService();

    final userAccounts = UserAccounts(
      id: '1',
      user_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final gardens = [
      Garden(
        id: '1',
        name: 'Test Garden',
        description: 'A beautiful test garden',
        account_id: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Garden(
        id: '2',
        name: 'Test Garden 2',
        description: 'Another beautiful test garden',
        account_id: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final gardenProvider = GardenProvider(mockGardenApiService);
    when(gardenProvider.fetchGarden(userAccounts.account_id))
        .thenAnswer((_) async => gardens);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => GardenProvider(mockGardenApiService),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(authApiService: mockAuthApiService),
          ),
        ],
        child: MaterialApp(
          home: GardenList(userAccounts: userAccounts),
        ),
      ),
    );

    await tester.pumpAndSettle();
	debugDumpApp();
    expect(find.text('Test Garden'), findsOneWidget);
    expect(find.text('Test Garden 2'), findsOneWidget);

    expect(find.byKey(Key('tagsButton')), findsOneWidget);
    expect(find.byKey(Key('addGardenButton')), findsOneWidget);
    expect(find.byKey(Key('logoutButton')), findsOneWidget);
 //   await tester.tap(find.byKey(Key('addGardenButton')));
 //   await tester.tap(find.byIcon(Icons.label));
 //   await tester.tap(find.byIcon(Icons.logout));
 //   await tester.pumpAndSettle();
//    expect(find.byType(GardenCreate), findsOneWidget);

    // Test the addGardenButton
    await tester.tap(find.byKey(Key('addGardenButton')));
    await tester.pumpAndSettle();
    expect(find.byType(GardenCreate), findsOneWidget); // Ensure navigation to GardenCreate

    // Test the tagsButton
    await tester.tap(find.byKey(Key('tagsButton')));
    await tester.pumpAndSettle();
    expect(find.byType(TagList), findsOneWidget); // Ensure navigation to TagList

    // Test the logoutButton
    await tester.tap(find.byKey(Key('logoutButton')));
    await tester.pumpAndSettle();
//    verify(mockAuthApiService.logout()).called(1); // Ensure logout is called
//    expect(find.byType(LandingPage), findsOneWidget);

  });
}
