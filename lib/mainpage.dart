import 'package:flutter/material.dart';
import 'package:elibrary/widgets/appbar_mainpage.dart';
import 'book.dart';
import 'widgets/bookinfo.dart';
import 'api.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final bookLoader = BookLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: FutureBuilder(
        future: bookLoader.loadBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}')); // Отображение сообщения об ошибке
          } else {
            return ListView.builder(
              itemCount: bookLoader.books.length,
              itemBuilder: (context, index) {
                final book = bookLoader.books[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          book.imageUrl,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 180,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(book.author),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    book.isFree ? 'Можно взять' : 'Забронирована',
                                    style: TextStyle(
                                      color: book.isFree ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => BookInfo(
                                          id: book.id,
                                          imageURL: book.imageUrl,
                                          name: book.title,
                                          author: book.author,
                                          isFree: book.isFree,
                                        ),
                                      );
                                    },
                                    child: const Text("Подробнее"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
