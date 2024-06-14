import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/ws.dart';
import 'package:frontend/model/apis/ws_api.dart';
import 'package:frontend/provider/ws_provider.dart';
import 'ws_provider_test.mocks.dart';
import 'dart:convert';

@GenerateMocks([http.Client, WsApiService])
void main() {
  late MockWsApiService mockWsApiService;
  late WsProvider wsProvider;

  setUp(() {
    mockWsApiService = MockWsApiService();
    wsProvider = WsProvider(mockWsApiService);
  });

  final ws = [
    WaterSchedule(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      monday: true,
      tuesday: true,
      wednesday: false,
      thursday: true,
      friday: false,
      saturday: false,
      sunday: true,
      method: 'Drip',
      notes: 'notes about ws.',
      plant_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    ),
  ];

  test('Fetch water schedule by plant id', () async {
    when(mockWsApiService.fetchWsApi('5d34bbee-7fc2-4e59-a513-6t729fuw3f'))
        .thenAnswer((_) async => ws);
    final result =
        await wsProvider.fetchWs('5d34bbee-7fc2-4e59-a513-6t729fuw3f');
    for (int i = 0; i < result.length; i++) {
      expect(result[i].id, ws[i].id);
      expect(result[i].monday, ws[i].monday);
      expect(result[i].tuesday, ws[i].tuesday);
      expect(result[i].wednesday, ws[i].wednesday);
      expect(result[i].thursday, ws[i].thursday);
      expect(result[i].friday, ws[i].friday);
      expect(result[i].saturday, ws[i].saturday);
      expect(result[i].sunday, ws[i].sunday);
      expect(result[i].method, ws[i].method);
      expect(result[i].notes, ws[i].notes);
      expect(result[i].plant_id, ws[i].plant_id);
      expect(result[i].createdAt, ws[i].createdAt);
      expect(result[i].updatedAt, ws[i].updatedAt);
    }
    verify(mockWsApiService.fetchWsApi('5d34bbee-7fc2-4e59-a513-6t729fuw3f'));
  });

  test('Create water schedule', () async {
    final createWs = WaterSchedule(
      id: 'fd824c99-0b27-4c1e-9d34-45021a112073',
      monday: true,
      tuesday: true,
      wednesday: false,
      thursday: true,
      friday: false,
      saturday: false,
      sunday: true,
      method: 'Drip',
      notes: 'notes about ws.',
      plant_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );
    when(mockWsApiService.createWsApi(createWs.toJson(), createWs.plant_id))
	.thenAnswer((_) async => createWs.toJson());
    await wsProvider.createWs(createWs.toJson(), createWs.plant_id);
       verify(mockWsApiService.createWsApi(createWs.toJson(), createWs.plant_id));
  });

  test('Update water schedule', () async {
    final updateWs = WaterSchedule(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      monday: true,
      tuesday: true,
      wednesday: false,
      thursday: true,
      friday: false,
      saturday: false,
      sunday: true,
      method: 'Drip',
      notes: 'notes about ws.',
      plant_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );
    when(mockWsApiService.updateWsApi(updateWs.toJson(), updateWs.plant_id, updateWs.id))
	.thenAnswer((_) async => [updateWs]);
    await wsProvider.updateWs(updateWs.toJson(), updateWs.plant_id, updateWs.id);
    verify(mockWsApiService.updateWsApi(updateWs.toJson(), updateWs.plant_id, updateWs.id));
  });

  test('Delete water schedule', () async {
    final deleteWs = WaterSchedule(
      id: '5d34bbee-7fc2-4e59-a513-9a234fsk23f',
      monday: true,
      tuesday: true,
      wednesday: false,
      thursday: true,
      friday: false,
      saturday: false,
      sunday: true,
      method: 'Drip',
      notes: 'notes about ws.',
      plant_id: '5d34bbee-7fc2-4e59-a513-6t729fuw3f',
      createdAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
      updatedAt: DateTime.parse('2024-05-23T11:57:57.906107Z'),
    );
    when(mockWsApiService.deleteWsApi(deleteWs.id))
	.thenAnswer((_) async => null);
    await wsProvider.deleteWs(deleteWs.id);
    verify(mockWsApiService.deleteWsApi(deleteWs.id));
  });
}
