import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch = rebuild this widget whenever the provider calls notifyListeners()
    final provider = context.watch<PostProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('API + Provider Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostProvider>().fetchPosts(),
          ),
        ],
      ),
      body: _buildBody(context, provider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PostProvider provider) {
    // 1. Loading state
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error state (with nothing to show)
    if (provider.error != null && provider.posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(provider.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.read<PostProvider>().fetchPosts(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Success state
    return RefreshIndicator(
      onRefresh: () => context.read<PostProvider>().fetchPosts(),
      child: ListView.builder(
        itemCount: provider.posts.length,
        itemBuilder: (context, index) {
          final post = provider.posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text('${post.id ?? '-'}')),
              title: Text(post.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
              Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add new post (POST)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final body = bodyController.text.trim();
                if (title.isEmpty || body.isEmpty) return;

                final messenger = ScaffoldMessenger.of(context);
                final ok = await context
                    .read<PostProvider>()
                    .addPost(Post(title: title, body: body));

                if (dialogContext.mounted) Navigator.pop(dialogContext);
                messenger.showSnackBar(SnackBar(
                  content: Text(ok
                      ? 'Post created (201)'
                      : (context.read<PostProvider>().error ?? 'Failed')),
                ));
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
