import 'package:flutter/material.dart';
import 'api.dart';
import 'package:elibrary/routes.dart';
import 'variables.dart';

class Authorise extends StatefulWidget {
  const Authorise({super.key});

  @override
  State<Authorise> createState() => _AuthoriseState();
}

class _AuthoriseState extends State<Authorise> {
  final _formKey = GlobalKey<FormState>();
  late String _login, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Card(
              child: SizedBox(
                width: constraints.maxWidth * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Вход в систему',
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Логин',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите логин';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _login = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Пароль',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите пароль';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:<Widget>[
                            ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              bool exists = await checkUser(_login, _password);

                              if (exists) {
                                
                                setUserId(_login);
                                if(_login=='admin'){
                                  isAdmin=true;
                                }
                                Navigator.pushReplacementNamed(context, AppRoutes.main);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Ошибка авторизации. Попробуйте снова')));
                              }
                            }
                          },
                          child: const Text('Войти'),
                        ),
                        ElevatedButton(
                          onPressed: () {  
                            Navigator.pushNamed(context, AppRoutes.reg);                                     
                          },
                          child: const Text('Регистрация'),
                        ),
                          ]
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

bool login(String login, String password) {
  return (login == 'admin' && password == 'qwerty');
}
