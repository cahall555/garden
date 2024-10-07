import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/plant.dart';
import 'package:frontend/model/apis/plant_api.dart';
import 'package:frontend/provider/plant_provider.dart';
import 'plant_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, PlantApiService])
void main() {
  late MockPlantApiService mockPlantApiService;
  late PlantProvider plantProvider;

  setUp(() {
    mockPlantApiService = MockPlantApiService();
    plantProvider = PlantProvider(mockPlantApiService);
  });

  final plants = [
    Plant(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      name: 'Tomato',
      germinated: true,
      days_to_harvest: 90,
      plant_count: 5,
      garden_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      account_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    ),
  ]; 

 test('Fetch plant by plant id and return 200', () async {
    when(mockPlantApiService.fetchPlantsApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
	.thenAnswer((_) async => plants);
    final result = await plantProvider.fetchPlants('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, plants[i].id);
      expect(result[i].name, plants[i].name);
      expect(result[i].germinated, plants[i].germinated);
      expect(result[i].days_to_harvest, plants[i].days_to_harvest);
      expect(result[i].plant_count, plants[i].plant_count);
      expect(result[i].garden_id, plants[i].garden_id);
      expect(result[i].account_id, plants[i].account_id);
      expect(result[i].createdAt, plants[i].createdAt);
      expect(result[i].updatedAt, plants[i].updatedAt);
    }
    verify(mockPlantApiService.fetchPlantsApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
  });

final createPlant = Plant(
    id: 'fd824c99-0b27-4c1e-9d34-45021a112073',
    name: 'Cherry Orchard',
    germinated: true,
    days_to_harvest: 90,
    plant_count: 5,
    garden_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    account_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );

  test('Create plant and return 201', () async {
    when(mockPlantApiService.createPlantApi(createPlant.toJson(), '5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
	.thenAnswer((_) async => null);
    await plantProvider.createPlant(createPlant.toJson(), '5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    verify(mockPlantApiService.createPlantApi(createPlant.toJson(), '5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
  });

  test('Update plant and return 200', () async {
    final updatePlant = Plant(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      name: 'Tomatoes',
      germinated: false,
      days_to_harvest: 90,
      plant_count: 5,
      garden_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      account_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );
    when(mockPlantApiService.updatePlantApi(updatePlant.toJson()))
	.thenAnswer((_) async => null);
    await plantProvider.updatePlant(updatePlant.toJson());
    verify(mockPlantApiService.updatePlantApi(updatePlant.toJson()));
  });

  test('Delete plant and return 200', () async {
    final deletePlant = Plant(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      name: 'Tomatoes',
      germinated: false,
      days_to_harvest: 90,
      plant_count: 5,
      garden_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      account_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );
    when(mockPlantApiService.deletePlantApi(deletePlant.id))
	.thenAnswer((_) async => null);
    await plantProvider.deletePlant(deletePlant.id);
    verify(mockPlantApiService.deletePlantApi(deletePlant.id));
  });
}

