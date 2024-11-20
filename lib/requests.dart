import 'package:flutter/material.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'api.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({Key? key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  late IO.Socket socket;
  late Stream<List<dynamic>> requestsStream;
  final StreamController<List<dynamic>> _streamController = StreamController();

  @override
  void initState() {
    super.initState();

    // Инициализация WebSocket-соединения
    socket = IO.io(
      'http://45.142.122.187:5000/',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    // Подключение к серверу
    socket.onConnect((_) {
      socket.emit('subscribe_requests');
    });

    // Слушатель обновлений заявок
    socket.on('request_update', (data) {
      // Передача новых данных в поток
      if (!_streamController.isClosed) {
        _streamController.add(data as List<dynamic>);
      }
    });

    // Закрываем поток при отмене
    _streamController.onCancel = () {
      socket.off('request_update');
      _streamController.close();
    };

    requestsStream = _streamController.stream;
  }

  @override
  void dispose() {
    socket.dispose();
    _streamController.close(); // Закрываем поток
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests List'),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: requestsStream, // Подключение к потоку
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет заявок.'));
          }

          final requests = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[requests.length - index - 1];
              final requestId = request['id'];
              final bookId = request['book_id'];
              final userId = request['user_id'];
              final status = request['status'] == null
                  ? 'Рассматривается'
                  : request['status'] == true
                      ? 'Подтверждена'
                      : 'Отказано';

              return FutureBuilder<Map<String, String>?>(
                future: fetchBookAndUserDetails(bookId, userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Ошибка: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final bookDetails = snapshot.data;
                    final bookTitle = bookDetails?['book_title'] ?? 'Неизвестно';
                    final username = bookDetails?['username'] ?? 'Неизвестный пользователь';

                    return Card(
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Подтвердить заявку?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    updateRequestStatus(requestId, true);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Подтвердить'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    updateRequestStatus(requestId, false);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Отклонить'),
                                ),
                              ],
                            ),
                          );
                        },
                        title: Text('Книга: $bookTitle'),
                        subtitle: RichText(
                          text: TextSpan(
                            text: 'Пользователь: $username\nСтатус заявки: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: status,
                                style: TextStyle(
                                  color: status == 'Рассматривается'
                                      ? Colors.orange
                                      : (status == 'Подтверждена'
                                          ? Colors.green
                                          : Colors.red),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Text('Данные не найдены');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
