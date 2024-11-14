import 'package:frontend/view/plant_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/ws.dart';
import 'package:frontend/model/plants_tag.dart';
import 'package:intl/intl.dart' as intl;
import 'package:test/test.dart' as function_test;
import 'package:frontend/model/tag.dart';
import 'package:frontend/model/journal.dart';
import 'package:frontend/model/apis/plant_api.dart';
import 'package:frontend/model/apis/tag_api.dart';
import 'package:frontend/model/apis/plants_tag_api.dart';
import 'package:frontend/model/apis/journal_api.dart';
import 'package:frontend/model/apis/ws_api.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'package:frontend/provider/plant_provider.dart';
import 'package:frontend/provider/tag_provider.dart';
import 'package:frontend/provider/plants_tag_provider.dart';
import 'package:frontend/provider/ws_provider.dart';
import 'package:frontend/provider/journal_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/account_provider.dart';
import 'package:frontend/provider/users_account_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'plant_detail_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  testWidgets('PlantDetail widget test', (WidgetTester tester) async {
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
    final tag = Tag(
      id: '1',
      name: 'Fruit',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final plantsTag = PlantTags(
      id: '1',
      plant_id: '1',
      tag_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final journal = Journal(
      id: '1',
      title: 'Test Title',
      entry: 'Test Entry',
      image: '',
      category: 'Pests',
      display_on_garden: false,
      plant_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final ws = WaterSchedule(
      id: '1',
      monday: true,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
      method: 'Drip',
      notes: 'Test notes',
      plant_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    mockClient = MockClient();
    final plantApiService = PlantApiService(mockClient);
    final tagApiService = TagApiService(mockClient);
    final plantsTagApiService = PlantsTagApiService(mockClient);
    final journalApiService = JournalApiService(mockClient);
    final wsApiService = WsApiService(mockClient);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlantProvider(plantApiService)),
          ChangeNotifierProvider(create: (_) => TagProvider(tagApiService)),
          ChangeNotifierProvider(
              create: (_) => PlantsTagProvider(plantsTagApiService)),
          ChangeNotifierProvider(
              create: (_) => JournalProvider(journalApiService)),
          ChangeNotifierProvider(create: (_) => WsProvider(wsApiService)),
        ],
        child: MaterialApp(
          home: PlantDetail(plant: plant),
        ),
      ),
    );
    expect(find.text('Tomato'), findsOneWidget);
    await tester.tap(find.byKey(Key('updatePlantButton')));
    expect(find.byIcon(Icons.edit), findsOneWidget);

  });
}
