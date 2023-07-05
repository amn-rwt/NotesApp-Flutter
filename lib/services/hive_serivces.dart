import 'package:hive/hive.dart';
import 'package:notes_app_bloc/model/todo_model.dart';

class HiveServices {
  static Box? todos;

  static void initializeDB() async {
    try {
      todos = await Hive.openBox('todos');
    } catch (e) {
      throw Exception(e);
    }
  }

  static void addTodo(int key, TodoModel todoModel) async {
    todos = Hive.box('todos');
    try {
      todos!.put(key, todoModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  static void deleteTodo(int key) async {
    try {
      todos!.delete(key);
    } catch (e) {
      throw Exception(e);
    }
  }

  static void clearAllTodos() {
    try {
      todos!.clear();
    } catch (e) {
      throw Exception(e);
    }
  }

  static void updateTodo(int key, TodoModel todoModel) async {
    try {
      todos!.put(key, todoModel);
    } catch (e) {
      throw Exception(e);
    }
  }
}
