import 'package:flutter/material.dart';
import 'package:elibrary/api.dart';
import 'bookinfo.dart';


class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          const Expanded(child: SearchBar()), // Поле поиска
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  void _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await searchBooks(query);
      setState(() => _searchResults = response);

      // Показываем результаты в Bottom Sheet
      _showSearchResults(context, _searchResults);
    } catch (e) {
      setState(() => _searchResults = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка поиска: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSearchResults(BuildContext context, List<dynamic> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Для возможности прокрутки
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final book = results[index];
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => BookInfo(
                        id: book['id'],
                        imageURL: book['image_url'],
                        name: book['title'],
                        author: book['author'],
                        isFree: book['isFree'],
                      ),
                    );
                  },
                  title: Text(book['title']),
                  subtitle: Text(book['author']),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(
                color: Colors.black
              ),
              controller: _controller,
              onSubmitted: _searchBooks,
              decoration: const InputDecoration(
                // labelStyle: TextStyle(color: Colors.black)),
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Поиск...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
