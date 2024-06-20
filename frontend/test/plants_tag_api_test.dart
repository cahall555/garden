import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/apis/custom_exception.dart';
import 'package:frontend/model/plants_tag.dart';
import 'package:frontend/model/apis/plants_tag_api.dart';
import 'plants_tag_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late PlantsTagApiService plantsTagApiService;

  setUp(() {
    mockClient = MockClient();
    plantsTagApiService = PlantsTagApiService(mockClient);
  });

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  group('fetchPlantsTagApi', () {
    final plantId = '5d34bbee-7fc2-4e59-a513-8b26245d5abf';
    final uri = Uri.parse(apiUrl + 'plantstag?plant_id=$plantId');
    const jsonString = """
[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","plant_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","tag_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

    final expectedPlantsTag = (json.decode(jsonString) as List)
        .map((data) => PlantTags.fromJson(data))
        .toList();

    test(
        'should return a list of plants tag with success when status code is 200',
        () async {
      when(mockClient.get(uri, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonString, 200));
      await plantsTagApiService.fetchPlantsTagApi(plantId);
      verify(mockClient.get(uri));
    });

    test('should throw an exception when status code is not 200', () async {
      when(mockClient.get(uri))
          .thenAnswer((_) async => http.Response('404 Not Found', 404));
      expect(() => plantsTagApiService.fetchPlantsTagApi(plantId),
          throwsException);
      verify(mockClient.get(uri));
    });
  });
  group('createPlantsTagApi', () {
    final plantTag = {
      'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      'tag_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf'
    };
    test('should return a plant tag with success when status code is 201',
        () async {
      final newPlantTag = PlantTags.fromJson({
        'id': 'bb28947d-0ddd-40f4-93b6-30e26db9405d',
        'plant_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
        'tag_id': '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
        'created_at': '2024-05-23T11:57:57.906107Z',
        'updated_at': '2024-05-23T11:57:57.906107Z'
      });
      final uri = Uri.parse(apiUrl + 'plantstag');
      when(mockClient.post(uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response(json.encode(newPlantTag), 201));
      await plantsTagApiService.createPlantsTagApi(plantTag);
      verify(mockClient.post(uri,
          headers: anyNamed('headers'), body: anyNamed('body')));
    });
    test('should throw an exception when status code is not 201', () async {
      final uri = Uri.parse(apiUrl + 'plantstag');
      when(mockClient.post(uri,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response('Failed to create plant tag', 404));
      expect(() => plantsTagApiService.createPlantsTagApi(plantTag),
          throwsException);
      verify(mockClient.post(uri,
          headers: anyNamed('headers'), body: anyNamed('body')));
    });
  });
}
