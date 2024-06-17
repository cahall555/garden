import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:io';
import 'package:frontend/model/journal.dart';
import 'package:frontend/model/apis/journal_api.dart';
import 'journal_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late JournalApiService journalApiService;

  setUp(() {
    mockClient = MockClient();
    journalApiService = JournalApiService(mockClient);
  });

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  const jsonString = """
[{"id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","title":"Journal Title","entry":"Journal Entry","display_on_garden": false, "category":"Harvest","plant_id":"5d34bbee-7fc2-4e59-a513-6t729fuw3f","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
    """;

  final expectedJournals = (json.decode(jsonString) as List)
      .map((data) => Journal.fromJson(data))
      .toList();
  test('Fetch journal by plant id and return 200', () async {
    final fetchUri = Uri.parse(
        apiUrl + 'plant_journals?plant_id=5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    when(mockClient.get(fetchUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await journalApiService
        .fetchPlantJournalApi('5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedJournals[i].id);
      expect(result[i].title, expectedJournals[i].title);
      expect(result[i].entry, expectedJournals[i].entry);
      expect(result[i].category, expectedJournals[i].category);
      expect(result[i].plant_id, expectedJournals[i].plant_id);
      expect(result[i].createdAt, expectedJournals[i].createdAt);
      expect(result[i].updatedAt, expectedJournals[i].updatedAt);
    }
    verify(mockClient.get(fetchUri, headers: anyNamed('headers')));
  });

  group('createJournalApi', () {
    const String plantId = '5d34bbee-7fc2-4e59-a513-6t729fuw3f';
    final Map<String, dynamic> journalData = {
      'title': 'Journal Title',
      'entry': 'Journal Entry',
      'category': 'Harvest',
      'plant_id': plantId,
      'display_in_garden': false,
    };

    test('successfully creates a journal entry', () async {
      final url = Uri.parse(apiUrl + 'journals?plantId=$plantId');
      final response = http.StreamedResponse(
          Stream.fromIterable([utf8.encode('{"status": "success"}')]), 200);

      when(mockClient.send(any)).thenAnswer((_) async => response);

      try {
        await journalApiService.createJournalApi(journalData, plantId, null);
        verify(mockClient.send(any)).called(1);
      } catch (e) {
        fail('Test failed with exception: $e');
      }
    });

    test('throws an exception when creation fails', () async {
      final url = Uri.parse(apiUrl + 'journals?plantId=$plantId');
      final response = http.StreamedResponse(
          Stream.fromIterable([utf8.encode('{"status": "error"}')]), 400);

      when(mockClient.send(any)).thenAnswer((_) async => response);

      try {
        await journalApiService.createJournalApi(journalData, plantId, null);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      verify(mockClient.send(any)).called(1);
    });
  });

  group('updateJournalApi', () {
    const String plantId = '5d34bbee-7fc2-4e59-a513-6t729fuw3f';
    const String journalId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
    final Map<String, dynamic> journalData = {
      'id': journalId,
      'title': 'Journal Title',
      'entry': 'Journal Entry',
      'category': 'Harvest',
      'plant_id': plantId,
      'display_in_garden': false,
      'created_at': '2024-05-23T11:57:57.906',
      'updated_at': '2024-05-23T11:57:57.906',
    };


test('Update journal entry successfully', () async {
      final url = Uri.parse(apiUrl + 'journals?id=$journalId&plantId=$plantId');
      final response = http.StreamedResponse(
          Stream.fromIterable([utf8.encode('{"status": "success"}')]), 200);

      when(mockClient.send(argThat(isA<http.MultipartRequest>()))).thenAnswer((_) async => response);

      try {
        await journalApiService.updateJournalApi(journalData, journalId, plantId, null);
      } catch (e) {
        fail('Test failed with exception: $e');
      }

      verify(mockClient.send(argThat(
        isA<http.MultipartRequest>()
            .having((req) => req.method, 'method', 'PUT')
            .having((req) => req.url.toString(), 'url', url.toString()),
      ))).called(1);
    });

    test('Update journal entry fails with error', () async {
      final url = Uri.parse(apiUrl + 'journals?id=$journalId&plantId=$plantId');
      final response = http.StreamedResponse(
          Stream.fromIterable([utf8.encode('{"error": "Failed to update"}')]),
          400);

      when(mockClient.send(any)).thenAnswer((_) async => response);

      try {
        await journalApiService.updateJournalApi(
            journalData, journalId, plantId, null);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      verify(mockClient.send(any)).called(1);
    });
  });

  test('Delete journal entry successfully', () async {
    const String journalId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
    final url = Uri.parse(apiUrl + 'journals/$journalId?id=$journalId');

    when(mockClient.delete(url, headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response('{"status": "success"}', 200));

    await journalApiService.deleteJournalApi(journalId);
    verify(mockClient.delete(url, headers: anyNamed('headers'))).called(1);
  });
}
