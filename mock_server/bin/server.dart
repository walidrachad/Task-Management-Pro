import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main(List<String> args) async {
  final dataDir = Directory(Platform.script.resolve('../data').toFilePath());
  final tasks = await _loadJsonList(File('${dataDir.path}/tasks.json'));
  final categories = await _loadJsonList(File('${dataDir.path}/categories.json'));

  stdout.writeln('Loaded ${tasks.length} tasks and ${categories.length} categories');

  final router = Router()
    ..get('/health', _health)
    ..get('/tasks', (Request _) => _tasksHandler(tasks))
    ..get('/tasks/<id>', (Request request, String id) => _taskByIdHandler(tasks, id))
    ..post('/tasks', (Request request) => _createTaskHandler(tasks, request))
    ..put('/tasks/<id>', (Request request, String id) => _updateTaskHandler(tasks, id, request))
    ..delete('/tasks/<id>', (Request request, String id) => _deleteTaskHandler(tasks, id))
    ..get('/categories', (Request _) => _categoriesHandler(categories))
    ..post('/auth/login', _loginHandler)
    ..options('/<ignored|.*>', _options);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router);

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('Mock server running on port ${server.port}');
}

Future<List<Map<String, dynamic>>> _loadJsonList(File file) async {
  if (!await file.exists()) return [];
  try {
    final raw = await file.readAsString();
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  } catch (_) {
    return [];
  }
}

Response _health(Request _) =>
    Response.ok(jsonEncode({'status': 'ok'}), headers: _jsonHeaders);

Response _jsonResponse(Object data) =>
    Response.ok(jsonEncode(data), headers: _jsonHeaders);

Response _options(Request _) => Response.ok('', headers: _corsHeaders);

Future<Response> _tasksHandler(List<Map<String, dynamic>> tasks) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));
  return _jsonResponse(tasks);
}

Future<Response> _categoriesHandler(List<Map<String, dynamic>> categories) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));
  return _jsonResponse(categories);
}

Future<Response> _taskByIdHandler(
  List<Map<String, dynamic>> tasks,
  String id,
) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));
  for (final task in tasks) {
    if (task['id']?.toString() == id) {
      return _jsonResponse(task);
    }
  }
  return Response.notFound(
    jsonEncode({'message': 'Task not found'}),
    headers: _jsonHeaders,
  );
}

Future<Response> _createTaskHandler(
  List<Map<String, dynamic>> tasks,
  Request request,
) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));

  try {
    final body = await request.readAsString();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return Response(
        HttpStatus.badRequest,
        body: jsonEncode({'message': 'Invalid payload'}),
        headers: _jsonHeaders,
      );
    }

    final newTask = Map<String, dynamic>.from(decoded);
    if (!newTask.containsKey('id')) {
      newTask['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    tasks.add(newTask);

    return Response(
      HttpStatus.created,
      body: jsonEncode(newTask),
      headers: _jsonHeaders,
    );
  } catch (e) {
    return Response(
      HttpStatus.badRequest,
      body: jsonEncode({'message': 'Failed to parse body'}),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> _updateTaskHandler(
  List<Map<String, dynamic>> tasks,
  String id,
  Request request,
) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));

  final index = tasks.indexWhere((task) => task['id']?.toString() == id);
  if (index == -1) {
    return Response.notFound(
      jsonEncode({'message': 'Task not found'}),
      headers: _jsonHeaders,
    );
  }

  try {
    final body = await request.readAsString();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return Response(
        HttpStatus.badRequest,
        body: jsonEncode({'message': 'Invalid payload'}),
        headers: _jsonHeaders,
      );
    }

    final updatedTask = {
      ...tasks[index],
      ...decoded,
      'id': tasks[index]['id'],
    };
    tasks[index] = updatedTask;

    return Response.ok(
      jsonEncode(updatedTask),
      headers: _jsonHeaders,
    );
  } catch (_) {
    return Response(
      HttpStatus.badRequest,
      body: jsonEncode({'message': 'Failed to parse body'}),
      headers: _jsonHeaders,
    );
  }
}

Future<Response> _deleteTaskHandler(
  List<Map<String, dynamic>> tasks,
  String id,
) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));

  final initialLength = tasks.length;
  tasks.removeWhere((task) => task['id']?.toString() == id);

  if (tasks.length == initialLength) {
    return Response.notFound(
      jsonEncode({'message': 'Task not found'}),
      headers: _jsonHeaders,
    );
  }

  return Response.ok(
    jsonEncode({'deleted': id}),
    headers: _jsonHeaders,
  );
}

Middleware _corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        ..._corsHeaders,
      });
    };
  };
}

Future<Response> _loginHandler(Request request) async {
  final delayMs = 200 + Random().nextInt(301); // 200-500ms
  await Future.delayed(Duration(milliseconds: delayMs));

  try {
    final body = await request.readAsString();
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return Response(
        HttpStatus.badRequest,
        body: jsonEncode({'message': 'Invalid payload'}),
        headers: _jsonHeaders,
      );
    }
    if (!decoded.containsKey('email') || !decoded.containsKey('password')) {
      return Response(
        HttpStatus.badRequest,
        body: jsonEncode({'message': 'Email and password required'}),
        headers: _jsonHeaders,
      );
    }
    return Response.ok(
      jsonEncode({'token': 'mock_token_123'}),
      headers: _jsonHeaders,
    );
  } catch (_) {
    return Response(
      HttpStatus.badRequest,
      body: jsonEncode({'message': 'Failed to parse body'}),
      headers: _jsonHeaders,
    );
  }
}

const _jsonHeaders = {
  ..._corsHeaders,
  HttpHeaders.contentTypeHeader: 'application/json',
};

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Requested-With',
};
