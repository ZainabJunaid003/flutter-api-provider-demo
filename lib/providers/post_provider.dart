import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostProvider extends ChangeNotifier {
  static final Uri _url =
  Uri.parse('https://jsonplaceholder.typicode.com/posts');

  List<Post> _posts = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  // GET request
  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // UI shows loading spinner

    try {
      final response =
      await http.get(_url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _posts = data
            .map((e) => Post.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = 'Server error. Status code: ${response.statusCode}';
      }
    } on SocketException {
      _error = 'No internet connection.';
    } catch (e) {
      _error = 'Something went wrong: $e';
    }

    _isLoading = false;
    notifyListeners(); // UI shows list or error
  }

  // POST request. Returns true on success.
  Future<bool> addPost(Post post) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    bool success = false;
    try {
      final response = await http
          .post(
        _url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(post.toJson()),
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        // 201 = Created. The API echoes back the new post with an id.
        final created =
        Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        _posts.insert(0, created);
        success = true;
      } else {
        _error = 'Could not create post. Status code: ${response.statusCode}';
      }
    } on SocketException {
      _error = 'No internet connection.';
    } catch (e) {
      _error = 'Something went wrong: $e';
    }

    _isSubmitting = false;
    notifyListeners();
    return success;
  }
}
