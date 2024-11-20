import 'package:elibrary/api.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  late Future<List<dynamic>> _requests;
  late String status;

  @override 
  void initState() {
    super.initState();
    _requests = fetchUserRequestsByID(id!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница пользователя'),
      ),
      body:FutureBuilder<List<dynamic>>(
        future: _requests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests found.'));
          } else {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  child: ListTile(
                    title: Text(request['book_title']),
                    subtitle: RichText(
                          text: TextSpan(
                            text: 'Статус заявки: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: request['status'] == null
                                      ? 'Рассматривается'
                                      : (request['status'] == true
                                          ? 'Одобрена'
                                          : 'Отклонена'),
                                style: TextStyle(
                                  color: request['status'] == null
                                      ? Colors.orange
                                      : (request['status'] == true
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
              },
            );
          }
        },
      ),
    );
  }
}