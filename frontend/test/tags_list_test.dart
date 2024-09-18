import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/model/tag.dart';
import 'package:frontend/provider/tag_provider.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/view/tags_list.dart';
import 'package:frontend/view/tag_create.dart';
import 'package:tags_list_test.mocks.dart';


@GenerateMocks([http.Client])
void main() {
	tagApiService = TagApiService(client);
  late MockTagProvider mockTagProvider;
  late UserAccounts mockUserAccount;
  late Tag mockTag;

  setUp(() {
	  mockTagProvider = MockTagProvider();
    mockUserAccount = UserAccounts(
        id: '1',
        account_id: '1',
        user_id: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<TagProvider>.value(
      value: mockTagProvider,
      child: MaterialApp(
        home: TagList(userAccounts: mockUserAccount),
      ),
    );
  }

  group('TagList Widget Tests', () {
    setUp(() {
      clearInteractions(mockTagProvider);
    });
    testWidgets('shows CircularProgressIndicator when data is loading',
        (WidgetTester tester) async {
      when(mockTagProvider.fetchTags(any)).thenAnswer((_) async => <Tag>[]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
/*
    testWidgets('shows "No tags found" when there are no tags',
        (WidgetTester tester) async {
      when(mockTagProvider.fetchTags(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('No tags found'), findsOneWidget);
    });

    testWidgets('displays list of tags when data is available',
        (WidgetTester tester) async {
      when(mockTagProvider.fetchTags(any)).thenAnswer((_) async => [
            Tag(
                id: '1',
                account_id: '1',
                name: 'Tag 1',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            Tag(
                id: '2',
                account_id: '1',
                name: 'Tag 2',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
          ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Tag 1'), findsOneWidget);
      expect(find.text('Tag 2'), findsOneWidget);
    });

    testWidgets('navigates to TagCreate when Add Tag button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Add Tag'), findsOneWidget);

      await tester.tap(find.text('Add Tag'));
      await tester.pumpAndSettle();

//      expect(find.byType(TagCreate), findsOneWidget);
    });
*/
  });
}
