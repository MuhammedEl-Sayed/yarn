import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/services/spool_service.dart';

/// Single place that talks to the API. Methods call the service first and then
/// swap in a NEW list, so `context.select` on `tasks` / `rooms` works.
class SpoolProvider extends ChangeNotifier {
  final SpoolService _service;
  SpoolProvider(this._service);

  List<Task> _tasks = const [];
  List<Room> _rooms = const [];
  bool _loading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  List<Room> get rooms => _rooms;
  bool get loading => _loading;
  String? get error => _error;

  Room? roomById(String? id) =>
      id == null ? null : _rooms.firstWhereOrNull((r) => r.id == id);

  Future<void> init() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getTasks(),
        _service.getRooms(),
      ]);
      _tasks = results[0] as List<Task>;
      _rooms = results[1] as List<Room>;
    } catch (e) {
      debugPrint('init failed: $e');
      _error = "Couldn't load your chores";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    final created = await _service.createTask(task);
    _tasks = [..._tasks, created];
    notifyListeners();
  }

  /// Saves edits to an existing task (name, repeat, room, ...).
  Future<void> updateTask(Task task) async {
    final saved = await _service.updateTask(task);
    _replaceTask(saved);
  }

  Future<void> toggleTask(Task task) async {
    final now = DateTime.now().toUtc();
    final flipped = task.copyWith(lastCompleted: task.isDoneToday ? null : now);
    _replaceTask(flipped);
    try {
      _replaceTask(await _service.updateTask(flipped));
    } catch (_) {
      _replaceTask(task);
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    await _service.deleteTask(id);
    _tasks = _tasks.where((t) => t.id != id).toList();
    notifyListeners();
  }

  /// Returns the created room so callers can attach starter chores to it.
  Future<Room> addRoom(Room room) async {
    final created = await _service.createRoom(room);
    _rooms = [..._rooms, created];
    notifyListeners();
    return created;
  }

  Future<void> updateRoom(Room room) async {
    final saved = await _service.updateRoom(room);
    _rooms = [for (final r in _rooms) r.id == saved.id ? saved : r];
    notifyListeners();
  }

  Future<void> deleteRoom(String id) async {
    await _service.deleteRoom(id);
    _rooms = _rooms.where((r) => r.id != id).toList();
    notifyListeners();
  }

  void _replaceTask(Task t) {
    _tasks = [for (final x in _tasks) x.id == t.id ? t : x];
    notifyListeners();
  }
}
