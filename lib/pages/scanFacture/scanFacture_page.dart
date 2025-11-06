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
  String recognizedText = ""; // result text
  List<TextElement> textElements = []; // individual text elements
  File? capturedImage; // store the captured image
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

    final RecognizedText result = await textRecognizer.processImage(inputImage);

    // Store individual text elements
    List<TextElement> elements = [];
    for (TextBlock block in result.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          elements.add(element);
        }
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
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(true);
                },
                child: const Text("Take Photo"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(false);
                },
                child: const Text("Pick from Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Text Recognition"),
          bottom: TabBar(
            tabs: const [
              Tab(text: "Full Text"),
              Tab(text: "Grid View"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Full text view
            Column(
              children: [
                // Main button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showImageSourceDialog,
                    child: const Text("Choose Image"),
                  ),
                ),
                // Display recognized text
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      recognizedText.isEmpty
                          ? "No text recognized yet."
                          : recognizedText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
            // Grid view
            Column(
              children: [
                // Main button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showImageSourceDialog,
                    child: const Text("Choose Image"),
                  ),
                ),
                // Image preview
                if (capturedImage != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        capturedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                // Grid of text elements
                Expanded(
                  child: textElements.isEmpty
                      ? const Center(
                          child: Text(
                            "No text elements found.\nTake a photo to see grid view.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element.text,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Confidence: ${(element.confidence! * 100).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
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
