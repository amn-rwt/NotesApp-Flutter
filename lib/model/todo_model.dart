// ignore: file_names
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  final String body;

  @HiveField(1)
  final bool isCompleted;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final DateTime? dateTime;

  TodoModel({
    required this.body,
    required this.isCompleted,
    this.priority = 'low',
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();
}
