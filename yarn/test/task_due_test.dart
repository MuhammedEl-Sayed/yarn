import 'package:flutter_test/flutter_test.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/utils/task_utils.dart';

DateTime _day(int offset) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day + offset);
}

Task _task(String unit, {DateTime? done, List<String> on = const [], int? monthlyOn}) =>
    Task(
      id: '1',
      createdBy: 'me',
      name: 'Chore',
      repUnit: unit,
      repeatsOn: on,
      monthlyOn: monthlyOn,
      lastCompleted: done?.add(const Duration(hours: 12)).toUtc(),
    );

String _code(int offset) => TaskUtils.dayCode(_day(offset).weekday);

void main() {
  test('weekly chore done yesterday is done, not due', () {
    final t = _task('week', done: _day(-1), on: [_code(-1)]);
    expect(t.isDone, isTrue);
    expect(t.isDue, isFalse);
    expect(t.dueDate, _day(6));
  });

  test('done two days early covers the upcoming scheduled day', () {
    final t = _task('week', done: _day(-2), on: [_code(0)]);
    expect(t.dueDate, _day(7));
    expect(t.isDue, isFalse);
  });

  test('done two days late covers the missed day', () {
    final t = _task('week', done: _day(0), on: [_code(-2)]);
    expect(t.dueDate, _day(5));
  });

  test('never-done weekly chore waits for its day', () {
    expect(_task('week', on: [_code(2)]).isDue, isFalse);
    expect(_task('week', on: [_code(2)]).dueDate, _day(2));
    expect(_task('week', on: [_code(0)]).isDue, isTrue);
  });

  test('daily chore done yesterday is due today', () {
    final t = _task('day', done: _day(-1));
    expect(t.isDue, isTrue);
    expect(t.isDone, isFalse);
  });

  test('daily chore missed for days is overdue', () {
    final t = _task('day', done: _day(-3));
    expect(t.isDue, isTrue);
    expect(t.dueDate, _day(-2));
  });

  test('one-time chore stays done', () {
    expect(_task('once', done: _day(-5)).isDone, isTrue);
    expect(_task('once').isDue, isTrue);
  });

  test('repeat labels', () {
    expect(_task('day').repeatLabel, 'Daily');
    expect(_task('month', monthlyOn: 31).repeatLabel, 'Monthly on the last day');
    expect(_task('month', monthlyOn: 2).repeatLabel, 'Monthly on the 2nd');
    expect(_task('once').repeatLabel, 'Once');
  });
}
