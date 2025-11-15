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
          title: const Text("Scan Facture"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Texte complet"),
              Tab(text: "Vue grille"),
            ],
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _showImageSourceDialog,
                  ),
                ),
                if (capturedImage != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(capturedImage!, fit: BoxFit.cover),
                    ),
                  ),
                Expanded(
                  child: textElements.isEmpty
                      ? Center(
                          child: Text(
                            "Aucun élément détecté.\nPrenez une photo pour voir la grille.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: textElements.length,
                          itemBuilder: (context, index) {
                            final element = textElements[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element.text,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Confiance : ${(element.confidence! * 100).toStringAsFixed(1)}%',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
