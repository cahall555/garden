import 'package:frontend/view/plant_detail.dart';
import 'package:flutter_test/flutter_test.dart' as widget_test;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/plants_tag.dart';
import 'package:intl/intl.dart' as intl;
import 'package:test/test.dart' as function_test;
import 'package:frontend/model/tag.dart';
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

class MockPlant extends Mock implements Plant {}
class MockTagProvider extends Mock implements TagProvider {}

class MockPlantsTagProvider extends Mock implements PlantsTagProvider {}

Widget wrapWithProviders(Widget child,
    {TagProvider? tagProvider, PlantsTagProvider? plantsTagProvider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GardenProvider()),
      ChangeNotifierProvider(create: (context) => PlantProvider()),
      ChangeNotifierProvider(create: (context) => WsProvider()),
      ChangeNotifierProvider(create: (context) => JournalProvider()),
      ChangeNotifierProvider(create: (context) => tagProvider ?? TagProvider()),
      ChangeNotifierProvider(
          create: (context) => plantsTagProvider ?? PlantsTagProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => AccountProvider()),
      ChangeNotifierProvider(create: (context) => UsersAccountsProvider()),
    ],
    child: child,
  );
}
@GenerateMocks([http.Client])
void main() {
	late MockClient mockClient;
	late Plant plant;

	setup(() {
		mockClient = MockClient();
		plant = Plant(MockClient());	
	});
//  final Plant plant = Plant(
//    id: '1',
//    name: 'Tomato',
//    germinated: true,
//    days_to_harvest: 60,
//    plant_count: 1,
//    date_planted: DateTime.parse('2024-05-26'),
//    date_germinated: null,
//    garden_id: '1',
//    account_id: '1',
//    createdAt: DateTime.now(),
//    updatedAt: DateTime.now(),
//  );
  function_test.group('Plant Detail date formating', () {
    function_test.test('Format Date in plant detail', () {
      final plantDetail = PlantDetail(plant: plant);

      function_test.expect(
          plantDetail.formatDate(plant.date_planted), 'May 26, 2024');
    });

    function_test.test('Format Date in plant detail, with no set date', () {
      final plantDetail = PlantDetail(plant: plant);

      function_test.expect(
          plantDetail.formatDate(plant.date_germinated), 'date not set');
    });

    function_test.test('Format Date in plant detail, testing year is zero', () {
      final plantDetail = PlantDetail(plant: plant);
      function_test.expect(
          plantDetail.formatDate(DateTime.parse("0000-12-31T23:59:35Z")),
          'date not set');
    });
  });
  widget_test.group('Plant Detail widget tests', () {
    widget_test.testWidgets('Plant Detail Widget Test',
        (widget_test.WidgetTester tester) async {
      await tester.pumpWidget(
          wrapWithProviders(MaterialApp(home: PlantDetail(plant: plant))));
      widget_test.expect(
          widget_test.find.text('Tomato'), widget_test.findsOneWidget);
      widget_test.expect(widget_test.find.text('plant has germinated'),
          widget_test.findsOneWidget);
      widget_test.expect(widget_test.find.text('Date Planted: May 26, 2024'),
          widget_test.findsOneWidget);
    });
    widget_test.testWidgets('Plant Detail Tags Widget Test',
        (widget_test.WidgetTester tester) async {
      final mockTagProvider = MockTagProvider();
      final mockPlantsTagProvider = MockPlantsTagProvider();

//      final PlantTags plantTag = PlantTags(
//        id: '1',
//        plant_id: '1',
//        tag_id: '1',
//        createdAt: DateTime.now(),
//        updatedAt: DateTime.now(),
//      );

//      final Tag tag = Tag(
//        id: '1',
//        name: 'Fruit',
//        account_id: '1',
//        createdAt: DateTime.now(),
//        updatedAt: DateTime.now(),
//      );

           print('**Testing***');
      print(plant.id);
      print(tag.name);
      when(mockPlantsTagProvider.fetchPlantsTag(plant.id))
          .thenAnswer((_) async => [plantTag]);
      when(mockTagProvider.fetchTag(plantTag.tag_id))
          .thenAnswer((_) async => [tag]);

      await tester.pumpWidget(wrapWithProviders(
        MaterialApp(home: PlantDetail(plant: plant)),
        tagProvider: mockTagProvider,
        plantsTagProvider: mockPlantsTagProvider,
      ));
       
      await tester.pumpAndSettle();

      widget_test.expect(
          widget_test.find.text('Fruit'), widget_test.findsOneWidget);
    });
  });
}
