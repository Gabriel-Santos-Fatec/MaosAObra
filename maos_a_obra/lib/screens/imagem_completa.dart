import 'package:flutter/material.dart';
import 'dart:io';

class FullScreenImageViewer extends StatelessWidget {
  final List<File> imageFiles;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageFiles,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: imageFiles.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(imageFiles[index]),
          );
        },
      ),
    );
  }
}
