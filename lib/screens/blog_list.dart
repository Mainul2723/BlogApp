import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BlogList extends StatefulWidget {
  const BlogList({Key? key}) : super(key: key);

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  List<Map<String, dynamic>> blogs = [];

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    final authToken = '137|ROLOym5mK7PygPXMFfyle769yFF1fDbTNzGLMtcG';

    final response = await http.get(
      Uri.parse('https://apitest.smartsoft-bd.com/api/admin/blog-news'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 1) {
        final List<dynamic> blogData = responseData['data']['blogs']['data'];

        setState(() {
          blogs = List<Map<String, dynamic>>.from(blogData);
        });
      } else {
        // Handle API error
        print('API Error: ${responseData['message']}');
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (blogs.isEmpty)
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final blog = blogs[index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color(0xff6ae792),
                        child: Text(
                          blogs[index].toString().substring(5, 8),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(blog['title']),
                      subtitle: Text(blog['sub_title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)),
                        ],
                      ),
                      onTap: () {
                        // Handle blog item tap
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
