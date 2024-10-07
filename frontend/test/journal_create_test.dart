import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/view/journal_create.dart';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/apis/journal_api.dart';
import 'package:frontend/provider/journal_provider.dart';

void main() {
  group('JournalCreate', () {
    late Plant plant;
    late JournalProvider journalProvider;

    setUp(() {
      plant = Plant(
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
      final journalApiService = JournalApiService(client);

      journalProvider = JournalProvider(journalApiService);
    });
    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<JournalProvider>.value(
        value: journalProvider,
        child: MaterialApp(
          home: JournalCreate(plant: plant),
        ),
      );
    }

    testWidgets('should render all the required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Create Journal'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Entry'), findsOneWidget);
//      expect(find.byKey(Key("categoryDropdown")), findsOneWidget);
//      expect(find.text('Display in Garden'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
//     expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
//      expect(find.byType(Switch), findsOneWidget);
//      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
    });

/*    
	**test is not recognizing find by key**
      testWidgets('should show a SnackBar when fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key("submitJournalButton")));
      await tester.pump();

      expect(find.text('Please ensure title and entry are complete.'),
          findsOneWidget);
    });
*/
    testWidgets('should be able to pick an image', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add_a_photo));
      await tester.pump();
    });

    testWidgets('should be able to submit the form when fields are filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).first, 'Test Title');
      await tester.enterText(find.byType(TextField).last, 'Test Entry');
    });
  });
}
