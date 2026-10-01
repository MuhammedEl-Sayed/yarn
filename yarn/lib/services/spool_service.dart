import 'package:dio/dio.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/services/token_store.dart';

class SpoolService {
  static const _baseUrl = String.fromEnvironment('SPOOL_BASE_URL');
  static const _jsonApi = 'application/vnd.api+json';

  final Dio dio;
  SpoolService(this.dio);

  factory SpoolService.create(TokenStore tokens) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Accept': _jsonApi, 'Content-Type': _jsonApi},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokens.read();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
    return SpoolService(dio);
  }

  Map<String, dynamic> _withId(Map resource) => {
    'id': resource['id'],
    ...Map<String, dynamic>.from(resource['attributes'] as Map),
  };

  Map<String, dynamic> _attrs(Map<String, dynamic> json) =>
      json
        ..remove('id')
        ..removeWhere((_, v) => v == null);

  // Tasks

  Future<List<Task>> getTasks() async {
    final res = await dio.get('/tasks');
    return (res.data['data'] as List)
        .map((e) => Task.fromJson(_withId(e as Map)))
        .toList();
  }

  Future<Task> createTask(Task task) async {
    final res = await dio.post(
      '/tasks',
      data: {
        'data': {'type': 'task', 'attributes': _attrs(task.toJson())},
      },
    );
    return Task.fromJson(_withId(res.data['data'] as Map));
  }

  Future<Task> updateTask(Task task) async {
    final attrs = _attrs(task.toJson())..remove('created_by');
    final res = await dio.patch(
      '/tasks/${task.id}',
      data: {
        'data': {'type': 'task', 'id': task.id, 'attributes': attrs},
      },
    );
    return Task.fromJson(_withId(res.data['data'] as Map));
  }

  Future<void> deleteTask(String id) async {
    await dio.delete('/tasks/$id');
  }

  // Rooms

  Future<List<Room>> getRooms() async {
    final res = await dio.get('/rooms');
    return (res.data['data'] as List)
        .map((e) => Room.fromJson(_withId(e as Map)))
        .toList();
  }

  Future<Room> createRoom(Room room) async {
    final res = await dio.post(
      '/rooms',
      data: {
        'data': {'type': 'room', 'attributes': _attrs(room.toJson())},
      },
    );
    return Room.fromJson(_withId(res.data['data'] as Map));
  }

  Future<Room> updateRoom(Room room) async {
    final attrs = _attrs(room.toJson())..remove('created_by');
    final res = await dio.patch(
      '/rooms/${room.id}',
      data: {
        'data': {'type': 'room', 'id': room.id, 'attributes': attrs},
      },
    );
    return Room.fromJson(_withId(res.data['data'] as Map));
  }

  Future<void> deleteRoom(String id) async {
    await dio.delete('/rooms/$id');
  }
}
