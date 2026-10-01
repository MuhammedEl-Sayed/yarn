import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';
import 'package:collection/collection.dart';
import 'package:yarn/services/tasks_service.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> tasks = [];

  TasksProvider(this.tasks);

  void init() async {
    SpoolService ts = SpoolService.create();
    updateTasks(await ts.getTasks());
  }

  void updateTasks(List<Task> newTasks) {
    tasks = newTasks;
    notifyListeners();
  }

  Task? findByTaskId(String id) {
    return tasks.firstWhereOrNull((task) => task.id == id);
  }

  void clearTasks() {
    tasks = [];
    notifyListeners();
  }

  void deleteByTaskId(String id) {
    try {
      tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print("Failed to delete $id: $e");
    }
  }

  void updateTask(Task newTask) {
    int? oldIndex = tasks.indexWhere((task) => task.id == newTask.id);
    if (oldIndex != -1) {
      tasks[oldIndex] = newTask;
      notifyListeners();
    } else {
      print("Failed to update ${newTask.id}: not found");
    }
  }
}
