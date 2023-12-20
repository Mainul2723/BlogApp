import 'package:blog/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReadBlog extends StatefulWidget {
  final Map<String, dynamic> blog;

  const ReadBlog({Key? key, required this.blog}) : super(key: key);

  @override
  _ReadBlogState createState() => _ReadBlogState();
}

class _ReadBlogState extends State<ReadBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryIDController = TextEditingController();
  TextEditingController videoController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    titleController.text = widget.blog['title'].toString();
    subTitleController.text = widget.blog['sub_title'].toString();
    slugController.text = widget.blog['slug'].toString();
    descriptionController.text = widget.blog['description'].toString();
    categoryIDController.text = widget.blog['category_id'].toString();
    videoController.text = widget.blog['video'].toString();
    dateController.text = widget.blog['date'].toString();
  }

  Future<void> updateBlog() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    final blogId = widget.blog['id'];

    final response = await http.post(
      Uri.parse(
          'https://apitest.smartsoft-bd.com/api/admin/blog-news/update/$blogId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'title': titleController.text,
        'sub_title': subTitleController.text,
        'slug': slugController.text,
        'description': descriptionController.text,
        'category_id': categoryIDController.text,
        'video': videoController.text,
        'date': dateController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successfully updated the blog
      print('Blog updated successfully!');
      print('Response: ${response.body}');
      Navigator.pop(context, true);
      // Pass true to indicate success
    } else {
      // Handle the error

      print('Failed to update blog. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
      Navigator.pop(context, false); // Pass false to indicate failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                textAlign: TextAlign.center,
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add some space between text fields
              TextField(
                textAlign: TextAlign.center,
                controller: subTitleController,
                decoration: InputDecoration(
                  hintText: "Sub-title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: slugController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Slug",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryIDController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Category ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: videoController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Video",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: dateController,
                //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateController.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () => updateBlog(),
                child: const Text('Update Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
