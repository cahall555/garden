import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'package:frontend/view/garden_list.dart';

class MockGardenProvider extends ChangeNotifier implements GardenProvider {
  @override
  Future<List<Garden>> fetchGarden(String accountId) async {
    await Future.delayed(Duration(seconds: 1)); 
    return [
      Garden(id: '123', name: 'Test Garden 1', description: 'A beautiful garden', account_id: '1', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Garden(id: '456', name: 'Test Garden 2', description: 'Another beautiful garden', account_id: '1', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];
  }
}

void main() {
  group('GardenList Widget Tests', () {
	  final userAccounts = UserAccounts(
      id: '1',
      user_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
	  final garden = Garden(
      id: '1',
      name: 'Test Garden',
      description: 'A beautiful test garden',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
	  final client = http.Client();
	  final gardenApiService = GardenApiService(client);
	
    testWidgets('Displays loading indicator while fetching gardens', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MockGardenProvider(gardenApiService)),
          ],
          child: MaterialApp(
            home: GardenList(userAccounts: UserAccounts()),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Test Garden 1'), findsOneWidget);
      expect(find.text('Test Garden 2'), findsOneWidget);
    });

    testWidgets('Displays error message on fetch error', (WidgetTester tester) async {
      final mockGardenProvider = MockGardenProvider();
      when(mockGardenProvider.fetchGarden(garden.id)).thenThrow(Exception('Failed to fetch gardens'));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => mockGardenProvider),
          ],
          child: MaterialApp(
            home: GardenList(userAccounts: UserAccounts(account_id: '1')),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Error: Failed to fetch gardens'), findsOneWidget);
    });
  });
}

