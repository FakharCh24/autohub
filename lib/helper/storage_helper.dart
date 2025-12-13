import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageHelper {
  StorageHelper._();
  static final StorageHelper instance = StorageHelper._();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = const Uuid();

  // ImgBB Configuration (Free alternative to Firebase Storage)
  static const String _imgbbApiKey =
      '66b492c564323df1ce0158cc5a99b2e3'; // Get from https://api.imgbb.com/
  static const bool _useImgBB =
      true; // Set to true to use ImgBB instead of Firebase

  // ImgBB Configuration (Free alternative to Firebase Storage)
  // static const String _imgbbApiKey = '66b492c564323df1ce0158cc5a99b2e3'; // Get from https://api.imgbb.com/
  // static const bool _useImgBB = true; // Set to true to use ImgBB instead of Firebase

  /// Upload image to ImgBB (Free alternative)
  Future<String?> _uploadToImgBB(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload?key=$_imgbbApiKey'),
        body: {'image': base64Image},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['url'];
      }

      print('ImgBB upload failed: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error uploading to ImgBB: $e');
      return null;
    }
  }

  /// Upload a single car image
  Future<String?> uploadCarImage(File imageFile) async {
    // Use ImgBB if enabled
    if (_useImgBB && _imgbbApiKey != 'YOUR_IMGBB_API_KEY') {
      return await _uploadToImgBB(imageFile);
    }

    // Otherwise use Firebase Storage (requires billing)
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Generate unique filename
      final String fileName = '${_uuid.v4()}.jpg';
      final String filePath = 'cars/$userId/$fileName';

      // Create reference
      final Reference ref = _storage.ref().child(filePath);

      // Upload file with metadata
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading car image: $e');
      return null;
    }
  }

  /// Upload multiple car images
  Future<List<String>> uploadCarImages(List<File> imageFiles) async {
    List<String> downloadUrls = [];

    for (File imageFile in imageFiles) {
      final url = await uploadCarImage(imageFile);
      if (url != null) {
        downloadUrls.add(url);
      }
    }

    return downloadUrls;
  }

  /// Upload profile picture
  Future<String?> uploadProfilePicture(File imageFile) async {
    // Use ImgBB if enabled
    if (_useImgBB && _imgbbApiKey != 'YOUR_IMGBB_API_KEY') {
      return await _uploadToImgBB(imageFile);
    }

    // Otherwise use Firebase Storage (requires billing)
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Use fixed filename for profile picture (will overwrite previous)
      final String filePath = 'profiles/$userId/profile.jpg';

      // Create reference
      final Reference ref = _storage.ref().child(filePath);

      // Upload file with metadata
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  /// Upload chat image
  Future<String?> uploadChatImage(File imageFile, String chatId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Generate unique filename
      final String fileName = '${_uuid.v4()}.jpg';
      final String filePath = 'chats/$chatId/$fileName';

      // Create reference
      final Reference ref = _storage.ref().child(filePath);

      // Upload file with metadata
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading chat image: $e');
      return null;
    }
  }

  /// Delete a file by URL
  Future<bool> deleteFile(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Delete multiple files by URLs
  Future<void> deleteFiles(List<String> downloadUrls) async {
    for (String url in downloadUrls) {
      await deleteFile(url);
    }
  }

  /// Get upload progress stream for a single file
  Stream<double> getUploadProgress(File imageFile, String folderPath) {
    final String fileName = '${_uuid.v4()}.jpg';
    final String filePath = '$folderPath/$fileName';
    final Reference ref = _storage.ref().child(filePath);
    final UploadTask uploadTask = ref.putFile(imageFile);

    return uploadTask.snapshotEvents.map((TaskSnapshot snapshot) {
      return snapshot.bytesTransferred / snapshot.totalBytes;
    });
  }
}
