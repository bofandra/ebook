import 'package:flutter/material.dart';

void main() {
  runApp(EbookSellingApp());
}

class EbookSellingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebook Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EbookStoreHome(),
    );
  }
}

class EbookStoreHome extends StatelessWidget {
  final List<Ebook> ebooks = [
    Ebook(
        title: 'Flutter Basics',
        author: 'John Doe',
        price: 9.99,
        content: 'This is the content of Flutter Basics.'),
    Ebook(
        title: 'Dart Advanced',
        author: 'Jane Smith',
        price: 12.99,
        content: 'This is the content of Dart Advanced.'),
    Ebook(
        title: 'Mobile UI Design',
        author: 'Alex Brown',
        price: 14.99,
        content: 'This is the content of Mobile UI Design.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ebook Store'),
      ),
      body: ListView.builder(
        itemCount: ebooks.length,
        itemBuilder: (context, index) {
          final ebook = ebooks[index];
          return ListTile(
            leading: Icon(Icons.book),
            title: Text(ebook.title),
            subtitle: Text('Author: ${ebook.author}\nPrice: \$${ebook.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for viewing ebooks here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EbookViewer(ebook: ebook),
                      ),
                    );
                  },
                  child: Text('View'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for purchasing ebooks here
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Purchase Ebook'),
                        content: Text(
                            'You purchased "${ebook.title}" for \$${ebook.price}!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Buy'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EbookViewer extends StatelessWidget {
  final Ebook ebook;

  EbookViewer({required this.ebook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ebook.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          ebook.content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class Ebook {
  final String title;
  final String author;
  final double price;
  final String content;

  Ebook(
      {required this.title,
      required this.author,
      required this.price,
      required this.content});
}
