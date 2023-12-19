import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Future<void> login(String email, password) async {
  //   final url = Uri.parse('https://apitest.smartsoft-bd.com/api/login');
  //   final response = await http.post(
  //     url,
  //     body: {
  //       'email': email,
  //       'password': password,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // Authentication successful, handle the response
  //     print('Authentication successful');
  //     print('Token: ${response.body}');
  //   } else {
  //     // Authentication failed, handle the error
  //     print('Authentication failed');
  //     print('Error: ${response.body}');
  //   }
  // }

  Future<void> login(String email, password) async {
    final url = Uri.parse('https://apitest.smartsoft-bd.com/api/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Authentication successful, handle the response
      print('Connection successful');
      print('Token: ${response.body}');
    } else {
      // Authentication failed, handle the error
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      print('Connection failed');
      print('Error Status: ${errorResponse['status']}');
      print('Error Message: ${errorResponse['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              login(emailController.text, passwordController.text);
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
