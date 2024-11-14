import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/plant_card.dart';
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'package:frontend/model/apis/plant_api.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'package:frontend/provider/plant_provider.dart';
import 'package:frontend/view/garden_detail.dart';

void main() {
  testWidgets('GardenDetail widget test', (WidgetTester tester) async {
    final garden = Garden(
      id: '1',
      name: 'Test Garden',
      description: 'A beautiful test garden',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final userAccounts = UserAccounts(
      id: '1',
      user_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final plant = Plant(
      id: '1',
      name: 'Tomato',
      germinated: true,
      days_to_harvest: 60,
      plant_count: 1,
      date_planted: DateTime.parse('2022-01-01'),
      date_germinated: DateTime.parse('2022-01-15'),
      garden_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
	final client = http.Client();
	final gardenApiService = GardenApiService(client);
	final plantApiService = PlantApiService(client);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GardenProvider(gardenApiService)),
          ChangeNotifierProvider(create: (_) => PlantProvider(plantApiService)),
        ],
        child: MaterialApp(
          home: GardenDetail(garden: garden, userAccounts: userAccounts),
        ),
      ),
    );

    await tester.pumpAndSettle();
    
    expect(find.text('Test Garden'), findsOneWidget);

    
    expect(find.text('Description: A beautiful test garden'), findsOneWidget);
    
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byKey(Key('updateGardenButton')), findsOneWidget);
    await tester.tap(find.byKey(Key('updateGardenButton')));
    await tester.pumpAndSettle();

//TODO: PlantCard tests
  });
}

