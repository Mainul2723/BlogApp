// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:blog/provider/auth.dart';
import 'package:blog/screens/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String token = responseBody['data']['token'];
      Provider.of<TokenProvider>(context, listen: false).setToken(token);

      print(token);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BlogList(),
        ),
      );
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
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "BlogApp",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          TextField(
            controller: emailController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Email",
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            obscureText: !isPasswordVisible,
            controller: passwordController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Password",
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Black background
              onPrimary: Colors.white, // White text
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 25), // Increased padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
            ),
            onPressed: () {
              login(emailController.text, passwordController.text);
            },
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18, // Slightly larger font size
                fontWeight: FontWeight.w500, // Semi-bold weight
              ),
            ),
          ),
        ],
      ),
    );
  }
}
