// ignore_for_file: unused_import

import 'package:blog/provider/auth.dart';
import 'package:blog/screens/blog_list.dart';
import 'package:blog/screens/crud/create.dart';
import 'package:blog/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // Access the TokenProvider
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);

    // Check if the user is authenticated
    final isAuthenticated = tokenProvider.token != null;

    // Return MaterialApp with appropriate home screen based on authentication status
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isAuthenticated ? const BlogList() : const Login(),
    );
  }
}
