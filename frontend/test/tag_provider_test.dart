import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/tag.dart';
import 'package:frontend/model/apis/tag_api.dart';
import 'package:frontend/provider/tag_provider.dart';
import 'tag_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, TagApiService])
void main() {
  late MockTagApiService mockTagApiService;
  late TagProvider tagProvider;

  setUp(() {
    mockTagApiService = MockTagApiService();
    tagProvider = TagProvider(mockTagApiService);
  });

  group('fetchTagByName', () {
    final name = 'Herb';
    final accountId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
    const jsonString = """
[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

    final expectedTags = (json.decode(jsonString) as List)
        .map((data) => Tag.fromJson(data))
        .toList();

    test('should return a list of tags with success when status code is 200',
        () async {
      when(mockTagApiService.fetchTagByNameApi(name, accountId))
          .thenAnswer((_) async => expectedTags);
      await tagProvider.fetchTagByName(name, accountId);
      verify(mockTagApiService.fetchTagByNameApi(name, accountId));
    });

    test('should throw an exception when status code is not 200', () async {
      when(mockTagApiService.fetchTagByNameApi(name, accountId))
          .thenAnswer((_) async => throw Exception('Failed to fetch tag'));
      final result = await tagProvider.fetchTagByName(name, accountId);
      expect(result, isNull);
      verify(mockTagApiService.fetchTagByNameApi(name, accountId));
    });
  });

  group('createTag', () {
    final tag = {
      'name': 'Herb',
      'account_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf'
    };
    test('should return a tag with success when status code is 200', () async {
      final newTag = Tag.fromJson({
        'id': 'bb28947d-0ddd-40f4-93b6-30e26db9405d',
        'name': 'Herb',
        'account_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
        'created_at': '2024-05-23T11:57:57.906107Z',
        'updated_at': '2024-05-23T11:57:57.906107Z'
      });
      when(mockTagApiService.createTagApi(tag)).thenAnswer((_) async => newTag);
      await tagProvider.createTag(tag);
      verify(mockTagApiService.createTagApi(tag));
    });
    test('should throw an exception when status code is not 200', () async {
      when(mockTagApiService.createTagApi(tag))
          .thenAnswer((_) async => throw Exception('Failed to create tag'));
      expect(() => tagProvider.createTag(tag), throwsException);
      verify(mockTagApiService.createTagApi(tag));
    });
  });
  group('updateTag', () {
	  final tagData = {
		  'name': 'Herb',
		  'account_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf'
	  };
	  final tagId = 'bb28947d-0ddd-40f4-93b6-30e26db9405d';
	  test('should return a tag with success when status code is 200', () async {
		  when(mockTagApiService.updateTagApi(tagData, tagId)).thenAnswer((_) async => http.Response('{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}', 200));
		  await tagProvider.updateTag(tagData, tagId);
		  verify(mockTagApiService.updateTagApi(tagData, tagId));
	  });
	  test('should throw an exception when status code is not 200', () async {
		  when(mockTagApiService.updateTagApi(tagData, tagId)).thenAnswer((_) async => throw Exception('Failed to update tag'));
		  expect(() => tagProvider.updateTag(tagData, tagId), throwsException);
		  verify(mockTagApiService.updateTagApi(tagData, tagId));
	  });
  });

  group('deleteTag', () {
	  final tagId = 'bb28947d-0ddd-40f4-93b6-30e26db9405d';
	  test('should return a tag with success when status code is 200', () async {
		  when(mockTagApiService.deleteTagApi(tagId)).thenAnswer((_) async => http.Response('{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}', 200));
		  await tagProvider.deleteTag(tagId);
		  verify(mockTagApiService.deleteTagApi(tagId));
	  });
	  test('should throw an exception when status code is not 200', () async {
		  when(mockTagApiService.deleteTagApi(tagId)).thenAnswer((_) async => throw Exception('Failed to delete tag'));
		  expect(() => tagProvider.deleteTag(tagId), throwsException);
		  verify(mockTagApiService.deleteTagApi(tagId));
	  });
  });

}
