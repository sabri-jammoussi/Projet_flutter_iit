import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'parametre_controller.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController()..initProfile(),
      builder: (context, child) {
        final controller = context.watch<ProfileController>();

        // Sync email text field with controller
        if (controller.email != null &&
            _emailController.text != controller.email) {
          _emailController.text = controller.email!;
        }

        // Show error message if any
        if (controller.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(controller.errorMessage!)),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètre'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Section
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Stack(
                      children: [
                        _buildAvatar(
                            controller.imageUrl, controller.selectedImageFile),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.camera_alt,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Email Field
                // TextField(
                //   controller: _emailController,
                //   decoration: const InputDecoration(
                //     labelText: 'Email',
                //     border: OutlineInputBorder(),
                //   ),
                //   onChanged: controller.setEmail,
                // ),
                // const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: controller.isSaving || controller.isUploading
                        ? null
                        : () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();

                            bool success = true;
                            // if (email.isNotEmpty && success) {
                            //   success =
                            //       await controller.updateEmail(email, password);
                            // }
                            if (success && password.isNotEmpty) {
                              success =
                                  await controller.updatePassword(password);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            }

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Profile updated successfully!'),
                                ),
                              );
                            }
                          },
                    child: controller.isSaving || controller.isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String? imageUrl, File? selectedFile) {
    if (selectedFile != null) {
      // Local file selected
      return CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(selectedFile),
      );
    } else if (imageUrl != null) {
      // Network image with loading indicator
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Image.network(
            imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // Image loaded
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, size: 60, color: Colors.white);
            },
          ),
        ),
      );
    } else {
      // No image available
      return const CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 60, color: Colors.white),
      );
    }
  }
}
