import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> tasks = [];

  TasksProvider(this.tasks);
}
