import 'package:elibrary/routes.dart';
import 'package:flutter/material.dart';
import 'package:elibrary/api.dart';
    
class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список пользователей'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка загрузки данных'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Нет пользователей'));
            } else {
              // Отображение списка пользователей
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return ListTile(
                    title: Text(user['username']),
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        AppRoutes.userInfo,
                        arguments: {
                          'username':user['username'],
                          'userId':user['id'],
                        }
                        );
                    },
                  );
                },
              );
            }
          },
        ),
    );
  }
}