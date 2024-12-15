import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

class EbookStoreHome extends StatefulWidget {
  @override
  _EbookStoreHomeState createState() => _EbookStoreHomeState();
}

class _EbookStoreHomeState extends State<EbookStoreHome> {
  late Future<List<Ebook>> ebooks;

  @override
  void initState() {
    super.initState();
    ebooks = fetchEbooks();
  }

  Future<List<Ebook>> fetchEbooks() async {
    final response = await http.get(Uri.parse('https://api.example.com/ebooks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ebook.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ebooks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ebook Store'),
      ),
      body: FutureBuilder<List<Ebook>>(
        future: ebooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ebooks = snapshot.data ?? [];
            return ListView.builder(
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
                        onPressed: () async {
                          final whatsappUrl = "https://wa.me/?text=I%20want%20to%20buy%20the%20ebook%20'${Uri.encodeComponent(ebook.title)}'%20for%20\$${ebook.price}";
                          if (await canLaunch(whatsappUrl)) {
                            await launch(whatsappUrl);
                          } else {
                            throw 'Could not launch $whatsappUrl';
                          }
                        },
                        child: Text('Buy'),
                      ),
                    ],
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

class EbookViewer extends StatefulWidget {
  final Ebook ebook;

  EbookViewer({required this.ebook});

  @override
  _EbookViewerState createState() => _EbookViewerState();
}

class _EbookViewerState extends State<EbookViewer> {
  final TextEditingController accessCodeController = TextEditingController();
  bool accessGranted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ebook.title),
      ),
      body: accessGranted
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.ebook.content,
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: accessCodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Access Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (accessCodeController.text == widget.ebook.accessCode) {
                        setState(() {
                          accessGranted = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid Access Code')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
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
  final String accessCode;

  Ebook({required this.title, required this.author, required this.price, required this.content, required this.accessCode});

  factory Ebook.fromJson(Map<String, dynamic> json) {
    return Ebook(
      title: json['title'],
      author: json['author'],
      price: json['price'].toDouble(),
      content: json['content'],
      accessCode: json['access_code'],
    );
  }
}
