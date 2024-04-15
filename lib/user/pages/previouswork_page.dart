import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreviousWorkPage extends StatefulWidget {
  const PreviousWorkPage({Key? key}) : super(key: key);

  @override
  _PreviousWorkPageState createState() => _PreviousWorkPageState();
}

class _PreviousWorkPageState extends State<PreviousWorkPage> {
  late Future<List<String>> _futureImages;

  @override
  void initState() {
    super.initState();
    _futureImages = _fetchImages();
  }

  Future<List<String>> _fetchImages() async {
    final String url = dotenv.env['GET_ALL_PREVIOUS_WORK_API']!;

    try {
      final request = http.Request('OPTIONS', Uri.parse(url));
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> previousWork =
            jsonData['previous_work'] as List<dynamic>;
        final List<String> imageUrls = previousWork
            .map<String>((item) => item['link'] as String? ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
        return imageUrls;
      } else {
        throw Exception('Failed to load image URLs');
      }
    } catch (error) {
      throw Exception('Error fetching image URLs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Work'),
      ),
      body: FutureBuilder<List<String>>(
        future: _futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<String> imageUrls = snapshot.data ?? [];
            if (imageUrls.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = imageUrls[index];
                  if (imageUrl == null || imageUrl.isEmpty) {
                    return const SizedBox
                        .shrink(); // Replace with your placeholder widget
                  } else {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    );
                  }
                },
              );
            } else {
              return Center(child: Text('No images found.'));
            }
          }
        },
      ),
    );
  }
}
