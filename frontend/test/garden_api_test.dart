import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/model/garden.dart';
import 'package:frontend/model/apis/garden_api.dart';
import 'garden_api_test.mocks.dart';

//TODO: unhappy path tests should be written as well.

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

  test('should throw format exception if the response body is not a list',
      () async {
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response('Not a list', 200));
    expect(
        () async => await gardenApiService
            .fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf'),
        throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'Failed to decode JSON data.',
            contains('Failed to decode JSON data'))));
    verify(mockClient.get(uri)).called(1);
  });

  final createUri = Uri.parse(apiUrl + 'gardens');
  final gardenData = {
    "name": "Herb Garden",
    "description": "So important for cooking.",
    "account_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf"
  };

  test('should create a garden with success when status code is 201', () async {
    when(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(gardenData)))
        .thenAnswer((_) async => http.Response(jsonString, 201));
    await gardenApiService.createGardenApi(gardenData);
    verify(mockClient.post(createUri,
        headers: anyNamed('headers'), body: json.encode(gardenData)));
  });

  final updateUri = Uri.parse(
      apiUrl + 'gardens?gardenId=bb28947d-0ddd-40f4-93b6-30e26db9405d');

  test('should throw an error when create garden fails.', () async {
    when(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(gardenData)))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(
        () async => await gardenApiService.createGardenApi(gardenData),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Failed to create garden'))));

    verify(mockClient.post(createUri,
            headers: anyNamed('headers'), body: json.encode(gardenData)))
        .called(1);
  });

  final updateGardenData = {
    "id": "bb28947d-0ddd-40f4-93b6-30e26db9405d",
    "name": "Herb Gardens",
    "description": "So important for cooking.Updated garden name.",
    "account_id": "5d34bbee-7fc2-4e59-a513-8b26245d5abf"
  };

  test('should update a garden with success when status code is 200', () async {
    when(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateGardenData)))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    await gardenApiService.updateGardenApi(
        updateGardenData, 'bb28947d-0ddd-40f4-93b6-30e26db9405d');
    verify(mockClient.put(updateUri,
        headers: anyNamed('headers'), body: json.encode(updateGardenData)));
  });

  final deleteUri = Uri.parse(apiUrl +
      'gardens/bb28947d-0ddd-40f4-93b6-30e26db9405d?id=bb28947d-0ddd-40f4-93b6-30e26db9405d');

  test('should fail when update data is not json', () async {
    when(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateGardenData)))
        .thenAnswer((_) async => http.Response('Not a JSON', 200));
    expect(
        () async => await gardenApiService.updateGardenApi(
            updateGardenData, 'bb28947d-0ddd-40f4-93b6-30e26db9405d'),
        throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'Failed to decode JSON data.',
            contains('Failed to decode JSON data'))));
    verify(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateGardenData)))
        .called(1);
  });

  test('should fail when http status code is not 200', () async {
    when(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateGardenData)))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(
        () async => await gardenApiService.updateGardenApi(
            updateGardenData, 'bb28947d-0ddd-40f4-93b6-30e26db9405d'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Request failed with status'))));
    verify(mockClient.put(updateUri,
            headers: anyNamed('headers'), body: json.encode(updateGardenData)))
        .called(1);
  });

  test('should delete a garden with success when status code is 200', () async {
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('', 200));
    await gardenApiService
        .deleteGardenApi('bb28947d-0ddd-40f4-93b6-30e26db9405d');
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')));
  });

  test('should fail to delete garden when status code is not 200', () async {
    when(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('{"status": "error"}', 500));
    expect(
        () async => await gardenApiService
            .deleteGardenApi('bb28947d-0ddd-40f4-93b6-30e26db9405d'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Failed to delete garden'))));
    verify(mockClient.delete(deleteUri, headers: anyNamed('headers')))
        .called(1);
  });

  final sqlInjectionUri = Uri.parse(apiUrl +
      'gardens/?account_id=5d34bbee-7fc2-4e59-a513-8b26245d5abf\' OR 1=1 --');

  test('should fail to retrieve gardens when there is a SQL injection attempt',
      () async {
    when(mockClient.get(sqlInjectionUri))
        .thenAnswer((_) async => http.Response('SQL Injection Detected', 400));
    try {
      await gardenApiService
          .fetchGardenApi('5d34bbee-7fc2-4e59-a513-8b26245d5abf\' OR 1=1 --');
      fail('Expected an exception due to SQL injection attempt');
    } catch (e) {
      expect(e.toString(), contains('Request failed with status'));
    }
    verify(mockClient.get(sqlInjectionUri));
  });
}
