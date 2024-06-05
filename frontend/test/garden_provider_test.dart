import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'package:frontend/provider/garden_provider.dart';
import 'garden_provider_test.mocks.dart';

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

  test('should return a list of gardens with success when status code is 200',
      () async {
    when(mockGardenApiService.fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'))
	.thenAnswer((_) async => gardens);
    final result = await gardenProvider.fetchGarden('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, gardens[i].id);
      expect(result[i].name, gardens[i].name);
      expect(result[i].description, gardens[i].description);
      expect(result[i].account_id, gardens[i].account_id);
      expect(result[i].createdAt, gardens[i].createdAt);
      expect(result[i].updatedAt, gardens[i].updatedAt);
    }
    verify(mockGardenApiService.fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'));
  });

}
