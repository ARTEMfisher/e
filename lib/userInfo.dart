import 'package:flutter/material.dart';
import 'api.dart'; // Импортируем функцию из api.dart

class UserInfo extends StatefulWidget {
  final int userId;

  const UserInfo({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<dynamic> requests = [];  // Список заявок пользователя
  bool isLoading = true;  // Флаг загрузки
  String errorMessage = '';  // Сообщение об ошибке

  @override
  void initState() {
    super.initState();
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),  // Отображаем имя пользователя
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())  // Индикатор загрузки
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))  // Сообщение об ошибке
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: requests.length,  // Количество заявок
                  itemBuilder: (context, index) {
                    final request = requests[index];  // Получаем заявку
                    return Card(
                      child: ListTile(
                        title: Text(request['bookTitle'] ?? 'Unknown Book'),  // Название книги
                        subtitle: Text('Status: ${request['status'] ?? 'Pending'}'),  // Статус заявки
                      ),
                    );
                  },
                ),
    );
  }
}
