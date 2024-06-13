import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/apis/plant_api.dart';
import 'plant_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late PlantApiService plantApiService;

  setUp(() {
    mockClient = MockClient();
    plantApiService = PlantApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

const jsonString = """
[{"id":"5d34bbee-7fc2-4e59-a513-9a234fsk23f","name":"Tomato","germinated":true,"days_to_harvest":90,"plant_count":5,"garden_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","account_id":"5d34bbee-7fc2-4e59-a513-6t729fuw3f","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

final expectedPlant = (json.decode(jsonString) as List)
    .map((data) => Plant.fromJson(data))
    .toList();


  test('Fetch plant by plant id and return 200', () async {
	  final fetchUri = Uri.parse(apiUrl + 'plants/5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    when(mockClient.get(fetchUri, headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response(jsonString, 200));
      final result = await plantApiService
        .fetchPlantApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
	for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedPlant[i].id);
      expect(result[i].name, expectedPlant[i].name);
      expect(result[i].germinated, expectedPlant[i].germinated);
      expect(result[i].days_to_harvest, expectedPlant[i].days_to_harvest);
      expect(result[i].plant_count, expectedPlant[i].plant_count);
      expect(result[i].garden_id, expectedPlant[i].garden_id);
      expect(result[i].account_id, expectedPlant[i].account_id);
      expect(result[i].createdAt, expectedPlant[i].createdAt);
      expect(result[i].updatedAt, expectedPlant[i].updatedAt);
    }
    verify(mockClient.get(fetchUri, headers: anyNamed('headers')));
  });


  test('Create plant and return 201', () async {
    final createUri = Uri.parse(apiUrl + 'plants?gardenId=5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    final plantData = {
      "name": "Tomato",
      "germinated": true,
      "days_to_harvest": 90,
      "plant_count": 5,
      "garden_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf",
      "account_id": "5d34bbee-7fc2-4e59-a513-6t729fuw3f"
    };
    when(mockClient.post(createUri,
	headers: anyNamed('headers'), body: json.encode(plantData)))
	.thenAnswer((_) async => http.Response(jsonString, 201));
    await plantApiService.createPlantApi(plantData, '5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    verify(mockClient.post(createUri,
	headers: anyNamed('headers'), body: json.encode(plantData)));
  });

  final updateUri = Uri.parse(apiUrl + 'plants?id=5d34bbee-7fc2-4e59-a513-9a234fsk23f');

  final updatePlantData = {
    "id": "5d34bbee-7fc2-4e59-a513-9a234fsk23f",
    "name": "Tomatoes",
    "germinated": false,
    "days_to_harvest": 90,
    "plant_count": 5,
    "garden_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf",
    "account_id": "5d34bbee-7fc2-4e59-a513-6t729fuw3f"
  };

  test('Update plant and return 200', () async {
    when(mockClient.put(updateUri,
	headers: anyNamed('headers'), body: json.encode(updatePlantData)))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    await plantApiService.updatePlantApi(updatePlantData);
    verify(mockClient.put(updateUri,
	headers: anyNamed('headers'), body: json.encode(updatePlantData)));
  });

  final deleteUri = Uri.parse(apiUrl + 'plants/5d34bbee-7fc2-4e59-a513-9a234fsk23f?id=5d34bbee-7fc2-4e59-a513-9a234fsk23f');

  test('Delete plant and return 200', () async {
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response('', 200));
    await plantApiService.deletePlantApi('5d34bbee-7fc2-4e59-a513-9a234fsk23f');
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
  });

  test('Sql injection test', () async {
    final sqlInjection = Uri.parse(apiUrl + 'plants/5d34bbee-7fc2-4e59-a513-8b26245d5abf; DROP TABLE plants');
    when(mockClient.get(sqlInjection, headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await plantApiService
	.fetchPlantApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf; DROP TABLE plants');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedPlant[i].id);
      expect(result[i].name, expectedPlant[i].name);
      expect(result[i].germinated, expectedPlant[i].germinated);
      expect(result[i].days_to_harvest, expectedPlant[i].days_to_harvest);
      expect(result[i].plant_count, expectedPlant[i].plant_count);
      expect(result[i].garden_id, expectedPlant[i].garden_id);
      expect(result[i].account_id, expectedPlant[i].account_id);
      expect(result[i].createdAt, expectedPlant[i].createdAt);
      expect(result[i].updatedAt, expectedPlant[i].updatedAt);
    }
    verify(mockClient.get(sqlInjection, headers: anyNamed('headers')));
  });

  test('XSS test', () async {
    final xss = Uri.parse(apiUrl + 'plants/5d34bbee-7fc2-4e59-a513-8b26245d5abf<script>alert(1)</script>');
    when(mockClient.get(xss, headers: anyNamed('headers')))
	.thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await plantApiService
	.fetchPlantApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf<script>alert(1)</script>');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedPlant[i].id);
      expect(result[i].name, expectedPlant[i].name);
      expect(result[i].germinated, expectedPlant[i].germinated);
      expect(result[i].days_to_harvest, expectedPlant[i].days_to_harvest);
      expect(result[i].plant_count, expectedPlant[i].plant_count);
      expect(result[i].garden_id, expectedPlant[i].garden_id);
      expect(result[i].account_id, expectedPlant[i].account_id);
      expect(result[i].createdAt, expectedPlant[i].createdAt);
      expect(result[i].updatedAt, expectedPlant[i].updatedAt);
    }
    verify(mockClient.get(xss, headers: anyNamed('headers')));
  });
}