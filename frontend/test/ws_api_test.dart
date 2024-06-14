import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/ws.dart';
import 'package:frontend/model/apis/ws_api.dart';
import 'ws_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  late MockClient mockClient;
  late WsApiService wsApiService;

  setUp(() {
    mockClient = MockClient();
    wsApiService = WsApiService(mockClient);
  });

  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final apiUrl = dotenv.env['API_URL'] ?? '';

  test('API URL is loaded', () {
    expect(apiUrl, isNotNull);
    expect(apiUrl, isNotEmpty);
  });

  const jsonString = """
[{"id":"5d34bbee-7fc2-4e59-a513-9a234fsk23f","monday":true,"tuesday":true,"wednesday":false,"thursday":true,"friday":false,"saturday":false,"sunday":true,"method":"Drip","notes":"notes about ws.","plant_id":"5d34bbee-7fc2-4e59-a513-6t729fuw3f","created_at":"2024-05-23T11:57:57.906107Z","updated_at":"2024-05-23T11:57:57.906107Z"}]
""";

  final expectedWs = (json.decode(jsonString) as List)
      .map((data) => WaterSchedule.fromJson(data))
      .toList();

  test('Fetch water schedule by plant id and return 200', () async {
    final fetchUri = Uri.parse(
        apiUrl + 'water_schedules?plant_id=5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    when(mockClient.get(fetchUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    final result =
        await wsApiService.fetchWsApi('5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, expectedWs[i].id);
      expect(result[i].monday, expectedWs[i].monday);
      expect(result[i].tuesday, expectedWs[i].tuesday);
      expect(result[i].wednesday, expectedWs[i].wednesday);
      expect(result[i].thursday, expectedWs[i].thursday);
      expect(result[i].friday, expectedWs[i].friday);
      expect(result[i].saturday, expectedWs[i].saturday);
      expect(result[i].sunday, expectedWs[i].sunday);
      expect(result[i].method, expectedWs[i].method);
      expect(result[i].notes, expectedWs[i].notes);
      expect(result[i].plant_id, expectedWs[i].plant_id);
      expect(result[i].createdAt, expectedWs[i].createdAt);
      expect(result[i].updatedAt, expectedWs[i].updatedAt);
    }
    verify(mockClient.get(fetchUri, headers: anyNamed('headers')));
  });

  test('Create water schedule and return 201', () async {
    final createUri = Uri.parse(
        apiUrl + 'water_schedules?plantId=5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    final createWs = {
      "monday": true,
      "tuesday": true,
      "wednesday": false,
      "thursday": true,
      "friday": false,
      "saturday": false,
      "sunday": true,
      "method": 'Drip',
      "notes": 'notes about ws.',
      "plant_id": '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
    };
    when(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(createWs)))
        .thenAnswer((_) async => http.Response(jsonString, 201));
    final result = await wsApiService.createWsApi(
        createWs, '5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    verify(mockClient.post(createUri,
        headers: anyNamed('headers'), body: json.encode(createWs)));
  });

  test('Update water schedule and return 201', () async {
    final updateUri = Uri.parse(apiUrl +
        'water_schedules?plantId=5d34bbee-7fc2-4e59-a513-6t729fuw3f&wsId=5d34bbee-7fc2-4e59-a513-9a234fsk23f');
    final updateWs = {
      "id": '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      "monday": true,
      "tuesday": true,
      "wednesday": false,
      "thursday": true,
      "friday": false,
      "saturday": false,
      "sunday": true,
      "method": 'Drip',
      "notes": 'notes about ws.',
      "plant_id": '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      "created_at": '2024-05-23T11:57:57.906107Z',
      "updated_at": '2024-05-23T11:57:57.906107Z',
    };
    when(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateWs)))
        .thenAnswer((_) async => http.Response(json.encode(updateWs), 201));
    final result = await wsApiService.updateWsApi(
        updateWs,
        '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
        '5d34bbee-7fc2-4e59-a513-9a234fsk23f');
    verify(mockClient.put(updateUri,
        headers: anyNamed('headers'), body: json.encode(updateWs)));
  });

  test('Delete water schedule and return 200', () async {
    final deleteUri = Uri.parse(
        apiUrl + 'water_schedules/5d34bbee-7fc2-4e59-a513-9a234fsk23f');
    final deleteWs = {
      "id": '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      "monday": true,
      "tuesday": true,
      "wednesday": false,
      "thursday": true,
      "friday": false,
      "saturday": false,
      "sunday": true,
      "method": 'Drip',
      "notes": 'notes about ws.',
      "plant_id": '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      "created_at": '2024-05-23T11:57:57.906107Z',
      "updated_at": '2024-05-23T11:57:57.906107Z',
    };
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(json.encode(deleteWs), 200));
    final result =
        await wsApiService.deleteWsApi('5d34bbee-7fc2-4e59-a513-9a234fsk23f');
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
  });
}
