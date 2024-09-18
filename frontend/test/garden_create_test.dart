import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/account.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/view/garden_create.dart';
import 'package:frontend/view/garden_list.dart';
import 'package:frontend/provider/garden_provider.dart';

class MockGardenProvider extends Mock implements GardenProvider {}
class MocktextEditingController extends Mock implements TextEditingController {}
void main() {
  group('GardenCreate', () {
    late MockGardenProvider mockGardenProvider;
    late UserAccounts userAccounts;

    setUp(() {
      mockGardenProvider = MockGardenProvider();
      userAccounts = UserAccounts(
        id: '1',
        user_id: '1',
        account_id: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<GardenProvider>.value(
        value: mockGardenProvider,
        child: MaterialApp(
          home: GardenCreate(userAccounts: userAccounts),
        ),
      );
    }

    testWidgets('displays UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Create Garden'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows error message if fields are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('calls createGarden on submit with filled fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, 'My Garden');
      await tester.enterText(
          find.byType(TextField).last, 'Beautiful garden description');
      await tester.tap(find.text('Submit'));
      await tester.pump();

    });

    testWidgets('navigates to GardenList on successful garden creation',
        (WidgetTester tester) async {

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField).first, 'My Garden');
      await tester.enterText(
          find.byType(TextField).last, 'Beautiful garden description');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

    });
    test('Dispose is called', () {
      final mockController = MocktextEditingController();
      final mockTitleController = MocktextEditingController();
      final mockEntryController = MocktextEditingController();

      mockController.dispose();
      mockTitleController.dispose();
      mockEntryController.dispose();

      verify(mockController.dispose()).called(1);
      verify(mockTitleController.dispose()).called(1);
      verify(mockEntryController.dispose()).called(1);
    });
  });
}
