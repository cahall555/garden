import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/journal.dart';
import 'package:frontend/model/apis/journal_api.dart';
import 'package:frontend/provider/journal_provider.dart';
import 'journal_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, JournalApiService])
void main() {
  late MockJournalApiService mockJournalApiService;
  late JournalProvider journalProvider;

  setUp(() {
    mockJournalApiService = MockJournalApiService();
    journalProvider = JournalProvider(mockJournalApiService);
  });

final journals = [
	Journal(
		id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
		title: 'Tomato',
		entry: 'Tomato is a red fruit',
		display_on_garden: true,
		category: 'Planting',
		plant_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
		createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
		updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
	),
];

test('Fetch journal by journal id and return 200', () async {
	when(mockJournalApiService.fetchPlantJournalApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
	.thenAnswer((_) async => journals);
	final result = await journalProvider.fetchPlantJournal('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
	for (int i = 0; i < result.length; i++) {
		expect(result[i].id, journals[i].id);
		expect(result[i].title, journals[i].title);
		expect(result[i].entry, journals[i].entry);
		expect(result[i].display_on_garden, journals[i].display_on_garden);
		expect(result[i].category, journals[i].category);
		expect(result[i].plant_id, journals[i].plant_id);
		expect(result[i].createdAt, journals[i].createdAt);
		expect(result[i].updatedAt, journals[i].updatedAt);
	}
	verify(mockJournalApiService.fetchPlantJournalApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
});

test('Create journal and return 200', () async {
	final journal = {
		'title': 'Tomato',
		'entry': 'Tomato is a red fruit',
		'display_on_garden': true,
		'category': 'Planting',
		'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
		'created_at': DateTime.parse('2024-05-23T11:57:57.906107Z'),
		'updated_at': DateTime.parse('2024-05-23T11:57:57.906107Z'),
	};
	when(mockJournalApiService.createJournalApi(journal, '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null))
	.thenAnswer((_) async => null);
	await journalProvider.createJournal(journal, '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null);
	verify(mockJournalApiService.createJournalApi(journal, '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null));
});

test('Update journal and return 200', () async {
	final journal = {
		'title': 'Tomato',
		'entry': 'Tomato is a red fruit',
		'display_on_garden': true,
		'category': 'Planting',
		'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
		'created_at': DateTime.parse('2024-05-23T11:57:57.906107Z'),
		'updated_at': DateTime.parse('2024-05-23T11:57:57.906107Z'),
	};
	when(mockJournalApiService.updateJournalApi(journal, '5d34bbee-7fc2-4e59-a513-9a234fsk23f', '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null))
	.thenAnswer((_) async => null);
	await journalProvider.updateJournal(journal, '5d34bbee-7fc2-4e59-a513-9a234fsk23f', '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null);
	verify(mockJournalApiService.updateJournalApi(journal, '5d34bbee-7fc2-4e59-a513-9a234fsk23f', '5d34bbee-7fc2-4e59-a513-8b26245d5abf', null));
});

test('Delete journal and return 200', () async {
	when(mockJournalApiService.deleteJournalApi('5d34bbee-7fc2-4e59-a513-9a234fsk23f'))
	.thenAnswer((_) async => null);
	await journalProvider.deleteJournal('5d34bbee-7fc2-4e59-a513-9a234fsk23f');
	verify(mockJournalApiService.deleteJournalApi('5d34bbee-7fc2-4e59-a513-9a234fsk23f'));
});





}
