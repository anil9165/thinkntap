import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktap/constants/api.dart';

import '../models/task.dart';

class ApiService {

  Future<List<Task>> fetchTasks(int page) async {
    print("page---${page}");
    final response = await http.get(Uri.parse('${Apis.baseUrl}?_page=$page&_limit=10'));
    print("list----${response.body}");
    print("list----${response.statusCode}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(Task task) async {
   Map data={
     "title":task.title,
     "completed":task.completed,
     "userId":task.userId
   };
    final response = await http.post(
      Uri.parse(Apis.baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    print("data----${data}");
    print("Add data----${response.body}");
    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('${Apis.baseUrl}/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('${Apis.baseUrl}/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
