import 'package:elibrary/variables.dart';
import 'package:flutter/material.dart';
import 'package:elibrary/api.dart';

class BookInfo extends StatefulWidget {
  final String name;
  final String author;
  final bool isFree;
  final String imageURL;
  final int id;

  const BookInfo({
    Key? key,
    required this.name,
    required this.author,
    required this.isFree,
    required this.imageURL,
    required this.id,
  }) : super(key: key);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book Info'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.imageURL),
          Text(
            ' ${widget.name}\n ${widget.author}',
            style: const TextStyle(fontSize: 18),
          ),
          widget.isFree ? const Text('Можно взять', style: TextStyle(color: Colors.green),) : const Text('Забронирована', style: TextStyle(color: Colors.red),)
        ],
      ),
      actions: [
  if (widget.isFree) 
    TextButton(
      onPressed: () { 
          createRequest(id!, widget.id);
      },
      child: const Text('Забронировать'),
    ),
  TextButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: const Text('OK'),
  ),
],

    );
  }
}
