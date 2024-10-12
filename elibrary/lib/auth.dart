import 'package:flutter/material.dart';

class Authorise extends StatefulWidget {
  const Authorise({super.key});

  @override
  State<Authorise> createState() => _AuthoriseState();
}

class _AuthoriseState extends State<Authorise> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Card(
      child: Column(
        children: [
          Text('Authorisation')
        ],
      ),
    ),);
  }
}