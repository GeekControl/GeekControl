import 'package:flutter/material.dart';
import '../animes/articles/entities/articles_entity.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late ArticlesEntity testContent;

  @override
  void initState() {
    super.initState();
    _refreshContent();
  }

  void _refreshContent() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'testContent.first.title',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshContent,
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
