import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostExamplePage extends StatefulWidget {
  @override
  _PostExamplePageState createState() => _PostExamplePageState();
}

class _PostExamplePageState extends State<PostExamplePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedFiles = [];

  Future<void> _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _selectedFiles = images.map((image) => File(image.path)).toList();
      });
    }
  }

  Future<void> _postContent() async {
    var url = Uri.parse('http://10.0.2.2:8000/posts/');
    var request = http.MultipartRequest('POST', url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;

    for (var file in _selectedFiles) {
      String? mimeType = lookupMimeType(file.path);
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();

      var mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

      request.files.add(
        http.MultipartFile(
          'files',
          fileStream,
          length,
          filename: basename(file.path),
          contentType: mediaType, // Correctly assign MediaType object
        ),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Post successful!');
      } else {
        print('Failed to post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Images'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _postContent,
              child: Text('Post'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Files:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._selectedFiles.map((file) => Text(basename(file.path))).toList(),
          ],
        ),
      ),
    );
  }
}
