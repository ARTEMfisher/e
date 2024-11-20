import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variables.dart';

String ip = 'http://45.142.122.187:5000/';

Future<bool> checkUser(String username, String password) async {
  final url = Uri.parse('${ip}check_user');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    // Проверяем код статуса ответа
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['valid'];
    } else {
      throw Exception('Failed to check user: ${response.statusCode}');
    }
  } catch (e) {
    // Возвращаем false в случае ошибки
    print(e); // Выводим ошибку в консоль для отладки
    return false; // Или можете пробросить исключение, если это необходимо
  }
}


Future<bool> addUser(String username, String password) async {
  
  final url = Uri.parse('${ip}add_user');

  try{
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    // Проверяем код статуса ответа
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to add user: ${response.statusCode}');
      
    }

  } catch (e) {
    print(e); 
    return false;}
  
  }

Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http.get(Uri.parse('${ip}users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((user) => {'id': user['id'], 'username': user['username']}).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }


Future<Map<String, dynamic>> fetchUserRequests(int userId) async {
  final url = Uri.parse('${ip}user_requests/$userId');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Допустим, response['requests'] содержит массив заявок с названием книги и статусом
      return {'success': true, 'data': data['requests']};
    } else {
      return {
        'success': false,
        'error': 'Failed to load data. Status Code: ${response.statusCode}'
      };
    }
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}


Future<List<dynamic>> fetchRequests() async {
  final url = Uri.parse('${ip}requests'); // Замените <your-server-ip> на ваш IP

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load requests: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<Map<String, dynamic>> createRequest(int userId, int bookId) async {
  final String url = '${ip}create_request';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'bookId': bookId,
      }),
    );

    if (response.statusCode == 201) {
      // Успешный запрос, возвращаем данные
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      // Ошибка сервера или данных
      return {
        'success': false,
        'error': jsonDecode(response.body)['message'] ??
            'Unknown error occurred'
      };
    }
  } catch (e) {
    // Обработка исключений
    return {'success': false, 'error': 'Failed to connect to the server'};
  }
}

Future<int?> fetchUserId(String username) async {
  final String url = '${ip}get_user_id';

  try {
    final response = await http.get(
      Uri.parse('$url?username=$username'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Возвращаем ID пользователя
      return jsonDecode(response.body)['user_id'];
    } else {
      print('Error: ${jsonDecode(response.body)['message']}');
      return null;
    }
  } catch (e) {
    // Обработка ошибок подключения
    print('Error: Failed to connect to the server');
    return null;
  }
}

void setUserId(String username) async {
  id = await fetchUserId(username); // Используйте await для получения значения из Future
  print(id);
}

Future<Map<String, String>?> fetchBookAndUserDetails(int bookId, int userId) async {
  final response = await http.get(
    Uri.parse('${ip}getUserAndBook?book_id=$bookId&user_id=$userId'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'book_title': data['book_title'],
      'username': data['username'],
    };
  } else {
    return null;  // В случае ошибки возвращаем null
  }
}


Future<void> updateRequestStatus(int requestId, bool status) async {
  final url = Uri.parse('${ip}update_request_status');
  
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    'requestId': requestId,
    'status': status,
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Request status updated: ${responseData}');
    } else {
      print('Error updating request: ${response.body}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<List<dynamic>> fetchUserRequestsByID(int userId) async {
    final url = Uri.parse('${ip}user_requests_by_id/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<List<dynamic>> searchBooks(String query) async {
  final url = Uri.parse('${ip}search_books?query=$query');
  final response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Ошибка загрузки данных');
  }
}
