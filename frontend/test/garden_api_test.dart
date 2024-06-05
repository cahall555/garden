import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'garden_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late GardenApiService gardenApiService;

  setUp(() {
    mockClient = MockClient();
    gardenApiService = GardenApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  final uri = Uri.parse(
      apiUrl + 'gardens/?account_id=5d34bbee-7fc2-4e59-a513-8b26245d5abf');
  const jsonString = """

[{"id":"bb28947d-0ddd-40f4-93b6-30e26db9405d","name":"Herb Garden","description":"So important for cooking.","account_id":"5d34bbee-7fc2-4e59-a513-8b26245d5abf","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]

  """;

  final expectedGardens = (json.decode(jsonString) as List)
      .map((data) => Garden.fromJson(data))
      .toList();

  test('should return a list of gardens with success when status code is 200',
      () async {
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await gardenApiService
        .fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedGardens[i].id);
      expect(result[i].name, expectedGardens[i].name);
      expect(result[i].description, expectedGardens[i].description);
      expect(result[i].account_id, expectedGardens[i].account_id);
      expect(result[i].createdAt, expectedGardens[i].createdAt);
      expect(result[i].updatedAt, expectedGardens[i].updatedAt);
    }
    verify(mockClient.get(uri));
  });
}
