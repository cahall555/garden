import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/tag.dart';
import 'package:frontend/model/users_account.dart';
import 'package:frontend/provider/tag_provider.dart';
import 'package:frontend/view/tags_list.dart';
import 'package:frontend/view/tag_detail.dart';
import 'package:frontend/view/tag_create.dart';
import 'package:frontend/model/apis/tag_api.dart';

// Generate the mock classes for TagProvider
@GenerateMocks([TagApiService])
import 'tags_list_test.mocks.dart';

void main() {
  // Set up test user account
  final testUserAccount = UserAccounts(
      id: '1',
      user_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  late MockTagApiService mockTagApiService;
  late TagProvider mockTagProvider;

  group('TagList Widget Tests', () {
    setUp(() {
      mockTagApiService = MockTagApiService();
      mockTagProvider = TagProvider(mockTagApiService);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider<TagProvider>.value(
          value: mockTagProvider,
          child: TagList(userAccounts: testUserAccount),
        ),
      );
    }

    testWidgets('displays loading spinner while fetching tags',
        (WidgetTester tester) async {
      // Arrange
      when(mockTagProvider.fetchTags(any))
          .thenAnswer((_) => Future.delayed(Duration(seconds: 1)));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays tag list when tags are fetched',
        (WidgetTester tester) async {
      // Arrange
      final testTags = [
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
      ];
      when(mockTagProvider.fetchTags(any)).thenAnswer((_) async => testTags);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // trigger FutureBuilder

      // Assert
      expect(find.text('Tag 1'), findsOneWidget);
      expect(find.text('Tag 2'), findsOneWidget);
    });
  });
}
