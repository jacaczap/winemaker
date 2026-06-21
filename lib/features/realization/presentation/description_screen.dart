import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({
    super.key,
    required this.title,
    required this.markdown,
  });

  final String title;
  final String markdown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Markdown(
                padding: const EdgeInsets.all(16),
                data: markdown,
                selectable: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () => context.pop(true),
                icon: const Icon(Icons.check),
                label: const Text('Mark as done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
