import 'package:flutter/material.dart';
import 'package:geekcontrol/animes/spoilers/entities/spoiler_entity.dart';
import 'package:geekcontrol/services/sites/intoxi_animes/webscraper/spoilers_scraper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class SpoilersDetailPage extends StatefulWidget {
  final SpoilersEntity spoiler;
  const SpoilersDetailPage({super.key, required this.spoiler});

  @override
  State<SpoilersDetailPage> createState() => _SpoilersDetailPageState();
}

class _SpoilersDetailPageState extends State<SpoilersDetailPage> {
  final SpoilersScrap _scrap = SpoilersScrap();
  List<String>? _spoilerContent;
  List<String?> images = [];

  @override
  void initState() {
    super.initState();
    _loadSpoilers();
  }

  Future<void> _loadSpoilers() async {
    try {
      final spoilersDetails = await _scrap.getDetails(entity: widget.spoiler);
      setState(() {
        _spoilerContent =
            spoilersDetails.map((detail) => detail.content).toList();
      });
    } catch (e) {
      Logger().e('Error loading spoilers details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Spoilers'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 60, 60, 60).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.spoiler.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.spoiler.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 4, 46, 80),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.spoiler.category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            if (_spoilerContent != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _spoilerContent!.map((content) {
                  return Text(
                    content,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 4, 46, 80),
                    ),
                    textAlign: TextAlign.start,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
