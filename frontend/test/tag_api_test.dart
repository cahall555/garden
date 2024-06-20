import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/tag.dart';
import 'package:frontend/model/apis/tag_api.dart';
import 'tag_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late TagApiService tagApiService;

  setUp(() {
    mockClient = MockClient();
    tagApiService = TagApiService(mockClient);
  });

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });


group('fetchTagByNameApi', () {
  final name = 'Herb';
  final accountId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
  final uri = Uri.parse(apiUrl + 'tag/$name?name=$name&account_id=$accountId');
  const jsonString = """
[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

  final expectedTags = (json.decode(jsonString) as List)
      .map((data) => Tag.fromJson(data))
      .toList();

  test('should return a list of tags with success when status code is 200',
      () async {
    when(mockClient.get(uri))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    await tagApiService.fetchTagByNameApi(name, accountId);
    verify(mockClient.get(uri));
  });

  test('should throw an exception when status code is not 200', () async {
    when(mockClient.get(uri))
	.thenAnswer((_) async => http.Response('Not Found', 404));
    expect(() => tagApiService.fetchTagByNameApi(name, accountId),
	throwsException);
    verify(mockClient.get(uri));
  });
});


group('fetchTagsApi', () {
  final accountId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
  final uri = Uri.parse(apiUrl + 'tags?account_id=$accountId');
  const jsonString = """
[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

  final expectedTags = (json.decode(jsonString) as List)
      .map((data) => Tag.fromJson(data))
      .toList();

  test('should return a list of tags with success when status code is 200',
      () async {
    when(mockClient.get(uri))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    await tagApiService.fetchTagsApi(accountId);
    verify(mockClient.get(uri));
  });

  test('should throw an exception when status code is not 200', () async {
    when(mockClient.get(uri))
	.thenAnswer((_) async => http.Response('Not Found', 404));
    expect(() => tagApiService.fetchTagsApi(accountId),
	throwsException);
    verify(mockClient.get(uri));
  });
});

group('createTagApi', () {
  final createUri = Uri.parse(apiUrl + 'tags');
  final tagData = {
    "name": "Herb",
    "account_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf"
  };
  const jsonString = """
{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}
""";
  test('should create a tag with success when status code is 200', () async {
    when(mockClient.post(createUri,
	    headers: anyNamed('headers'), body: json.encode(tagData)))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    await tagApiService.createTagApi(tagData);
    verify(mockClient.post(createUri,
	headers: anyNamed('headers'), body: json.encode(tagData)));
  });

  test('should throw an exception when status code is not 200', () async {
    when(mockClient.post(createUri,
	    headers: anyNamed('headers'), body: json.encode(tagData)))
	.thenAnswer((_) async => http.Response('Not Created', 404));
    expect(() => tagApiService.createTagApi(tagData),
	throwsException);
    verify(mockClient.post(createUri,
	headers: anyNamed('headers'), body: json.encode(tagData)));
  });
});

group('updateTagApi', () {
	final updateUri = Uri.parse(apiUrl + 'tags?tagId=bb28947d-0ddd-40f4-93b6-30e26db9405d');
	final tagData = {
		"name": "Herb",
		"account_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf"
	};
	const jsonString = """
{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}
""";
	test('should update a tag with success when status code is 200', () async {
		when(mockClient.put(updateUri,
			headers: anyNamed('headers'), body: json.encode(tagData)))
		.thenAnswer((_) async => http.Response(jsonString, 200));
		await tagApiService.updateTagApi(tagData, 'bb28947d-0ddd-40f4-93b6-30e26db9405d');
		verify(mockClient.put(updateUri,
			headers: anyNamed('headers'), body: json.encode(tagData)));
	});

	test('should throw an exception when status code is not 200', () async {
		when(mockClient.put(updateUri,
			headers: anyNamed('headers'), body: json.encode(tagData)))
		.thenAnswer((_) async => http.Response('Not Updated', 404));
		expect(() => tagApiService.updateTagApi(tagData, 'bb28947d-0ddd-40f4-93b6-30e26db9405d'),
		throwsException);
		verify(mockClient.put(updateUri,
			headers: anyNamed('headers'), body: json.encode(tagData)));
	});
});

group('deleteTagApi', () {
	final deleteUri = Uri.parse(apiUrl + 'tags/bb28947d-0ddd-40f4-93b6-30e26db9405d');
	test('should delete a tag with success when status code is 200', () async {
		when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
		.thenAnswer((_) async => http.Response('Deleted', 200));
		await tagApiService.deleteTagApi('bb28947d-0ddd-40f4-93b6-30e26db9405d');
		verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
	});
});
}
