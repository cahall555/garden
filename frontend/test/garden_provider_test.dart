import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'garden_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, GardenApiService])
void main() {
  late MockGardenApiService mockGardenApiService;
  late GardenProvider gardenProvider;

  setUp(() {
    mockGardenApiService = MockGardenApiService();
    gardenProvider = GardenProvider(mockGardenApiService);
  });

  final gardens = [
    Garden(
      id: 'bb28947d-0ddd-40f4-93b6-30e26db9405d',
      name: 'Herb Garden',
      description: 'So important for cooking.',
      account_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    ),
  ];

  test(
      'Fetch Garden should return a list of gardens with success when status code is 200',
      () async {
    when(mockGardenApiService
            .fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
        .thenAnswer((_) async => gardens);
    final result = await gardenProvider
        .fetchGarden('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, gardens[i].id);
      expect(result[i].name, gardens[i].name);
      expect(result[i].description, gardens[i].description);
      expect(result[i].account_id, gardens[i].account_id);
      expect(result[i].createdAt, gardens[i].createdAt);
      expect(result[i].updatedAt, gardens[i].updatedAt);
    }
    verify(mockGardenApiService
        .fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
  });

  final createGarden = Garden(
    id: 'fd824c99-0b27-4c1e-9d34-45021a112073',
    name: 'Cherry Orchard',
    description: 'For making cherry cider.',
    account_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );

  test(
      'Create Garden should return a list of gardens with success when status code is 201',
      () async {
    when(mockGardenApiService.createGardenApi(createGarden.toJson()))
        .thenAnswer((_) async => null);
    await gardenProvider.createGarden(createGarden.toJson());
    int index =
        gardenProvider.gardens.indexWhere((g) => g.name == createGarden.name);
    if (index != -1) {
      expect(gardenProvider.gardens[index].name, createGarden.name);
      expect(
          gardenProvider.gardens[index].description, createGarden.description);
      expect(gardenProvider.gardens[index].account_id, createGarden.account_id);
    }
    verify(mockGardenApiService.createGardenApi(createGarden.toJson()));
  });

  final updatedGarden = Garden(
    id: 'bb28947d-0ddd-40f4-93b6-30e26db9405d',
    name: 'Herb Gardens',
    description: 'So important for cooking. Updated garden name.',
    account_id: '5d34bbee-7fc2-4e59-a513-8b26245d5abf',
    createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
  );

  test(
      'Update Garden should return a list of gardens with success when status code is 200',
      () async {
    when(mockGardenApiService.updateGardenApi(any, any))
        .thenAnswer((_) async => gardens);
    await gardenProvider.updateGarden(updatedGarden.toJson(), updatedGarden.id);
    int index =
        gardenProvider.gardens.indexWhere((g) => g.id == updatedGarden.id);
    if (index != -1) {
      expect(gardenProvider.gardens[index].id, updatedGarden.id);
      expect(gardenProvider.gardens[index].name, updatedGarden.name);
      expect(
          gardenProvider.gardens[index].description, updatedGarden.description);
      expect(
          gardenProvider.gardens[index].account_id, updatedGarden.account_id);
      expect(gardenProvider.gardens[index].createdAt, updatedGarden.createdAt);
      expect(gardenProvider.gardens[index].updatedAt, updatedGarden.updatedAt);
    }
    verify(mockGardenApiService.updateGardenApi(
        updatedGarden.toJson(), updatedGarden.id));
  });

  test(
      'Delete Garden should return a list of gardens with success when status code is 200',
      () async {
    when(mockGardenApiService.deleteGardenApi(gardens[0].id))
        .thenAnswer((_) async => null);
    await gardenProvider.deleteGarden(gardens[0].id);
    int index = gardenProvider.gardens.indexWhere((g) => g.id == gardens[0].id);
    expect(index, -1);
    verify(mockGardenApiService.deleteGardenApi(gardens[0].id));
  });
}
