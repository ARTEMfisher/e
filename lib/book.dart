import 'dart:convert';
import 'package:http/http.dart' as http;



class Book {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final List<String> holders;
  final bool isFree;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.holders,
    required this.isFree,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      imageUrl: json['image_url'],
      holders: List<String>.from(json['holders'] ?? []),
      isFree: json['isFree'],
    );
  }
}

class BookLoader {
  List<Book> books = []; // Список книг

  // Метод для загрузки книг из API
  Future<void> loadBooks() async {
    final response = await http.get(Uri.parse('http://45.142.122.187:5000/books'));

    if (response.statusCode == 200) {
      // Если запрос успешен, преобразуем JSON в список книг
      final List<dynamic> decodedJson = json.decode(response.body);
      books = decodedJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Не удалось загрузить книги'); // Обработка ошибки
    }
  }
}


