import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class ProfileController with ChangeNotifier {
  static const String cloudName = 'dawprvlpi';
  static const String uploadPreset = 'projet_dentiste';

  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user data
  String? _email;
  String? _imageUrl;
  File? _selectedImageFile;
  bool _isUploading = false;
  String? _errorMessage;
  bool _isSaving = false;
  String? _uploadedUrl;
  // Getters
  String? get email => _email;
  String? get imageUrl => _imageUrl;
  File? get selectedImageFile => _selectedImageFile;
  bool get isUploading => _isUploading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  // Initialize from current user
  Future<void> initProfile() async {
    final user = _auth.currentUser;
    _imageUrl = null;
    if (user != null) {
      _email = user.email;

      try {
        // 🔍 Find document where email matches logged-in user's email
        final query = await _firestore
            .collection('profile')
            .where('email', isEqualTo: _email)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final data = query.docs.first.data();
          _imageUrl = data['profile_image'] as String?;
          print('✅ Loaded profile image: $_imageUrl');
        } else {
          print('⚠️ No profile found for email $_email');
        }
      } catch (e) {
        print('🔥 Error fetching profile: $e');
        _errorMessage = 'Failed to load profile';
      }

      notifyListeners();
    }
  }

  // Pick and upload image
  Future<void> pickImage() async {
    _clearError();
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    _selectedImageFile = File(picked.path);
    notifyListeners();

    final uploadedUrl = await _uploadToCloudinary(_selectedImageFile!);
    if (uploadedUrl != null) {
      _imageUrl = uploadedUrl;
      await _saveImageUrlToFirestore(uploadedUrl);
    }
  }

  // Upload to Cloudinary
  Future<String?> _uploadToCloudinary(File file) async {
    _isUploading = true;
    notifyListeners();

    try {
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      final length = await file.length();
      final multipartFile = http.MultipartFile('file', stream, length,
          filename: path.basename(file.path));
      request.files.add(multipartFile);

      final response = await request.send();
      final resp = await http.Response.fromStream(response);

      if (resp.statusCode == 200) {
        final data = _parseJson(resp.body);
        _uploadedUrl = data['secure_url'] as String?;
        if (_uploadedUrl != null) {
          // ✅ Save full Cloudinary response to Firestore
          await _saveToFirestore(data);
        } else {
          _errorMessage = 'Upload succeeded but no secure_url found.';
        }
      } else {
        _errorMessage = 'Upload failed: ${resp.statusCode}';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Upload error: $e';
      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  // Save image URL to Firestore
  Future<void> _saveImageUrlToFirestore(String url) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('profile').doc(user.uid).set(
      {'imageUrl': url},
      SetOptions(merge: true),
    );
  }

// Update email (Firebase Auth + Firestore)
  Future<bool> updateEmail(String newEmail, String currentPassword) async {
    _clearError();
    _isSaving = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      // 🔐 Reauthenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: "123123",
      );

      await user.reauthenticateWithCredential(credential);

      print("🔐 Reauthenticated successfully");

      // Update Auth email
      await user.updateEmail(newEmail);
      await user.sendEmailVerification();

      // Update Firestore
      await _firestore.collection('profile').doc(user.uid).set({
        'email': newEmail,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _email = newEmail;

      // Logout
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context as BuildContext, '/login', (route) => false);

      return true;
    } catch (e) {
      print("❌ ERROR updateEmail: $e");
      _errorMessage = 'Email update failed: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Update password (Firebase Auth)
  Future<bool> updatePassword(String newPassword) async {
    _clearError();
    _isSaving = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      _errorMessage = 'Password update failed: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _saveToFirestore(Map<String, dynamic> cloudinaryResponse) async {
    try {
      // 🔑 Get current user (ensure Firebase Auth is initialized)
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _errorMessage = 'No user logged in. Cannot save profile.';
        return;
      }

      // 📁 Reference: /profile/{userId}
      final profileRef =
          FirebaseFirestore.instance.collection('profile').doc(user.uid);

      // 🖼️ Extract only the secure_url from Cloudinary response
      final secureUrl = cloudinaryResponse['secure_url'];

      if (secureUrl == null) {
        _errorMessage = 'No secure_url found in Cloudinary response.';
        return;
      }

      // 📤 Save secure_url and email
      await profileRef.set({
        'profile_image': secureUrl,
        'email': user.email, // 👈 Add the email
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ Image URL and email saved to Firestore.');
    } catch (e) {
      _errorMessage = 'Failed to save to Firestore: $e';
      debugPrint(_errorMessage);
    }
  }

  // Safe JSON parsing
  Map<String, dynamic> _parseJson(String responseBody) {
    try {
      return json.decode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  void _clearError() {
    _errorMessage = null;
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
