import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/post_provider.dart';
import 'screens/post_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // ..fetchPosts() calls the API as soon as the provider is created
      create: (_) => PostProvider()..fetchPosts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Provider Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const PostListScreen(),
    );
  }
}
