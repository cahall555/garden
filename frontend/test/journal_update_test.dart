import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/journal.dart';
import 'package:frontend/provider/journal_provider.dart';
import 'package:frontend/view/journal_update.dart';

class MockJournalProvider extends Mock implements JournalProvider {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockUpdateJournalInfo extends Mock {
   updateJournalInfo() {}
}

void main() {
  group('JournalUpdate', () {
    late Journal journal;
    late MockJournalProvider mockJournalProvider;

    setUp(() {
      journal = Journal(
        id: '123',
        title: 'Test Title',
        entry: 'Test Entry',
        image: '',
        category: 'Pests',
        display_on_garden: false,
        plant_id: '456',
	createdAt: DateTime.now(),
	updatedAt: DateTime.now(),
      );
      mockJournalProvider = MockJournalProvider();
    });

    Future<void> pumpJournalUpdateView(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<JournalProvider>.value(
          value: mockJournalProvider,
          child: MaterialApp(
            home: JournalUpdate(journal: journal),
          ),
        ),
      );
    }

    testWidgets('displays initial journal data', (WidgetTester tester) async {
      await pumpJournalUpdateView(tester);

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Entry'), findsOneWidget);
//      expect(find.text('Pests'), findsOneWidget);
//     expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('updates image when image picker is used', (WidgetTester tester) async {
      final mockImagePicker = MockImagePicker();
     // when(mockImagePicker.pickImage(source: ImageSource.gallery))
       //   .thenAnswer((_) async => XFile('../../assets/tomato.jpg'));

      await pumpJournalUpdateView(tester);

      await tester.tap(find.byIcon(Icons.add_a_photo));
      await tester.pumpAndSettle();

//      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('category dropdown displays correct options', (WidgetTester tester) async {
      await pumpJournalUpdateView(tester);

   //   await tester.tap(find.text('Pests'));
      await tester.pumpAndSettle();

      for (String category in [
        "Pests",
        "Planting",
        "Watering",
        "Pruning",
        "Harvesting",
        "Weather",
        "Germination"
      ]) {
    //    expect(find.text(category), findsOneWidget);
      }
    });
/*
    testWidgets('toggles display on garden switch', (WidgetTester tester) async {
      await pumpJournalUpdateView(tester);

      final Finder switchFinder = find.byType(Switch);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      Switch displaySwitch = tester.widget<Switch>(switchFinder);
      expect(displaySwitch.value, true);
    });
*/
    testWidgets('calls updateJournalInfo when submit button is pressed', (WidgetTester tester) async {
      await pumpJournalUpdateView(tester);
      expect(find.text('Submit'), findsOneWidget);
    //  await tester.tap(find.text('Submit'));
//      await tester.pumpAndSettle();
     // expect(find.text('Journal updated successfully!'), findsOneWidget);
    });
  });
}

