import 'dart:convert';
import 'package:blog/provider/auth.dart';
import 'package:blog/screens/crud/create.dart';
import 'package:blog/screens/crud/read.dart';
import 'package:blog/screens/crud/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http.get(
      Uri.parse('https://apitest.smartsoft-bd.com/api/admin/blog-news'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 1) {
        final List<dynamic> blogData = responseData['data']['blogs']['data'];

        setState(() {
          blogs = List<Map<String, dynamic>>.from(blogData);
          print(token);
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

  Future<void> deleteBlog(int index) async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;

    final blogId = blogs[index]['id'];

    final response = await http.delete(
      Uri.parse(
          'https://apitest.smartsoft-bd.com/api/admin/blog-news/delete/$blogId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted the blog
      print('Blog deleted successfully!');
      print('Response: ${response.body}');

      // Update the UI by refetching the blogs
      await fetchBlogs();
    } else {
      // Handle the error
      print('Failed to delete blog. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateBlog(),
                ),
              );
              fetchBlogs();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchBlogs(), // Callback function for refresh action
        child: Column(
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBlog(blog: blog),
                                  ),
                                ).then((result) {
                                  if (result != null && result as bool) {
                                    // Update the UI by refetching the blogs
                                    fetchBlogs();
                                  }
                                });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () => deleteBlog(index),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadBlog(
                                blog: blog,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
