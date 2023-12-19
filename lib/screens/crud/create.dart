import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController slugController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryIDController = TextEditingController();
  TextEditingController videoController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final String token = '137|ROLOym5mK7PygPXMFfyle769yFF1fDbTNzGLMtcG';

  @override
  void initState() {
    super.initState();

    // Set default values if needed
    videoController.text = 'https://www.youtube.com/watch?v=s7wmiS2mSXY';
  }

  Future<void> createBlog() async {
    final url =
        Uri.parse('https://apitest.smartsoft-bd.com/api/admin/blog-news/store');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'title': titleController.text,
        'sub_title': subtitleController.text,
        'slug': slugController.text,
        'description': descriptionController.text,
        'category_id': categoryIDController.text,
        'video': videoController.text,
        'date': dateController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successfully created the blog
      print('Blog created successfully!');
      print('Response: ${response.body}');
      
    } else {
      // Handle the error
      print('Failed to create blog. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Blog"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              controller: subtitleController,
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
              onPressed: createBlog,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
