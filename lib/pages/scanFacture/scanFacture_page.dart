import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionPage extends StatefulWidget {
  const RecognitionPage({super.key});

  @override
  State<RecognitionPage> createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  String recognizedText = "";
  List<TextElement> textElements = [];
  File? capturedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(bool fromCamera) async {
    final XFile? pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    await _recognizeText(imageFile);
  }

  Future<void> _recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    final result = await textRecognizer.processImage(inputImage);

    List<TextElement> elements = [];
    for (final block in result.blocks) {
      for (final line in block.lines) {
        elements.addAll(line.elements);
      }
    }

    setState(() {
      recognizedText = result.text;
      textElements = elements;
      capturedImage = image;
    });

    await textRecognizer.close();
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Choisir une image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Prendre une photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                _pickImage(true);
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text("Depuis la galerie"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                _pickImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).appBarTheme.foregroundColor,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Scan Facture",
            style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      secondary: Theme.of(context).primaryColor,
                    ),
                tabBarTheme: TabBarTheme(
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                ),
              ),
              child: const TabBar(
                tabs: [
                  Tab(text: "Texte complet"),
                  Tab(text: "Vue grille"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Vue texte complet
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.image_search),
                    label: const Text("Choisir une image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _showImageSourceDialog,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      recognizedText.isEmpty
                          ? "Aucun texte reconnu pour le moment."
                          : recognizedText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),

            // Vue grille
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.image_search),
                    label: const Text("Choisir une image"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _showImageSourceDialog,
                  ),
                ),
                if (capturedImage != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(capturedImage!, fit: BoxFit.cover),
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        // Header
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xfff0f0f0)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Prestation",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Prix",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Consultation"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("80.00"),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Nettoyage dents"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("120.00"),
                            ),
                          ],
                        ),
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xfff0f0f0)),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Total TTC",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("200.00",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("TVA"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("19%"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
