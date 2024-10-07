import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/plants_tag.dart';
import 'package:frontend/model/apis/plants_tag_api.dart';
import 'package:frontend/provider/plants_tag_provider.dart';
import 'plants_tag_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, PlantsTagApiService])
void main() {
  late MockPlantsTagApiService mockPlantsTagApiService;
  late PlantsTagProvider plantsTagProvider;

  setUp(() {
    mockPlantsTagApiService = MockPlantsTagApiService();
    plantsTagProvider = PlantsTagProvider(mockPlantsTagApiService);
  });

  group('fetchPlantsTag', () {
	  final plantId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';

	  const jsonString = """
[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","plant_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","tag_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

	  final expectedPlantsTag = (json.decode(jsonString) as List)
		  .map((data) => PlantTags.fromJson(data))
		  .toList();

	  test(
		  'should return a list of plants tag with success when status code is 200',
		  () async {
		  when(mockPlantsTagApiService.fetchPlantsTagApi(plantId))
			  .thenAnswer((_) async => expectedPlantsTag);
		  await plantsTagProvider.fetchPlantsTag(plantId);
		  verify(mockPlantsTagApiService.fetchPlantsTagApi(plantId));
	  });

	  test('should throw an exception when status code is not 200', () async {
		  when(mockPlantsTagApiService.fetchPlantsTagApi(plantId))
			  .thenAnswer((_) async => throw Exception('Failed to fetch plants tag'));
		  final result = await plantsTagProvider.fetchPlantsTag(plantId);
		  expect(result, []);
		  verify(mockPlantsTagApiService.fetchPlantsTagApi(plantId));
	  });
  });

  group('createPlantsTag', () {
	  final plantTag = {
		  'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
		  'tag_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf'
	  };
	  test('should return a plants tag with success when status code is 200', () async {
		  final newPlantsTag = PlantTags.fromJson({
			  'id': 'bb28947d-0ddd-40f4-93b6-30e26db9405d',
			  'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
			  'tag_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
			  'created_at': '2024-05-23T11:57:57.906107Z',
			  'updated_at': '2024-05-23T11:57:57.906107Z'
		  });
		  when(mockPlantsTagApiService.createPlantsTagApi(plantTag))
			  .thenAnswer((_) async => newPlantsTag);
		  await plantsTagProvider.createPlantsTag(plantTag);
		  verify(mockPlantsTagApiService.createPlantsTagApi(plantTag));
	  });
  });
}
