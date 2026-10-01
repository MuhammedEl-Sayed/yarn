import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yarn/models/task.dart';

class SpoolService {
  final Dio dio;

  SpoolService(this.dio);

  factory SpoolService.create({String? token}) {
    return SpoolService(
      Dio(
        BaseOptions(
          baseUrl: dotenv.env['SPOOL_BASE_URL']!,
          headers: {
            'Acceptokent': 'application/vnd.api+json',
            'Content-Type': 'application/vnd.api+json',
            if (token != null)
              'Authorization': 'Bearer ${dotenv.env['SPOOL_API_KEY']}',
          },
        ),
      ),
    );
  }

  Task _fromResource(Map<String, dynamic> resource) {
    return Task.fromJson({
      'id': resource['id'],
      ...Map<String, dynamic>.from(resource['attributes'] as Map),
    });
  }

  Map<String, dynamic> _attributes(Task task) {
    return task.toJson()..remove('id');
  }

  Future<List<Task>> getTasks() async {
    final res = await dio.get('/tasks');
    final data = res.data['data'] as List;
    return data
        .map((e) => _fromResource(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Task> createTask(Task task) async {
    final res = await dio.post(
      '/tasks',
      data: {
        'data': {'type': 'task', 'attributes': _attributes(task)},
      },
    );
    return _fromResource(Map<String, dynamic>.from(res.data['data']));
  }

  Future<Task> updateTask(Task task) async {
    final attrs = _attributes(task)..remove('created_by');
    final res = await dio.patch(
      '/tasks/${task.id}',
      data: {
        'data': {'type': 'task', 'id': task.id, 'attributes': attrs},
      },
    );
    return _fromResource(Map<String, dynamic>.from(res.data['data']));
  }

  Future<void> deleteTask(String id) async {
    await dio.delete('/tasks/$id');
  }


Future<List<Task>> getRooms() async {
  final res = await dio.get('/rooms');
  final data = res.data['data'] as List;
  return data.map((e) => _fromResource(Map<String, dynamic>.from(e))).toList();
}

Future<Task> createTask(Task task) async {
  final res = await dio.post(
    '/tasks',
    data: {
      'data': {'type': 'task', 'attributes': _attributes(task)},
    },
  );
  return _fromResource(Map<String, dynamic>.from(res.data['data']));
}

Future<Task> updateTask(Task task) async {
  final attrs = _attributes(task)..remove('created_by');
  final res = await dio.patch(
    '/tasks/${task.id}',
    data: {
      'data': {'type': 'task', 'id': task.id, 'attributes': attrs},
    },
  );
  return _fromResource(Map<String, dynamic>.from(res.data['data']));
}

Future<void> deleteTask(String id) async {
  await dio.delete('/tasks/$id');
}
