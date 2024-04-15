import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminUserPreviousWork extends StatefulWidget {
  const AdminUserPreviousWork({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminUserPreviousWorkState createState() => _AdminUserPreviousWorkState();
}

class _AdminUserPreviousWorkState extends State<AdminUserPreviousWork> {
  bool _isEditing = false;
  final List<WorkItem> _workItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Work'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _isEditing
                ? null
                : () {
              // Add image functionality
              _addImage(context);
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: _workItems.length,
        itemBuilder: (context, index) {
          final workItem = _workItems[index];
          return GestureDetector(
            onTap: () {
              if (!_isEditing) {
                _showTitleDialog(context, workItem);
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image.file(
                        File(workItem.imagePath),
                        fit: BoxFit.cover,
                      ),
                      if (_isEditing)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _workItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Text(workItem.title), // Display title under the image
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addImage(BuildContext context) async {
    final pickedImage = await _pickImageFromGallery();
    if (pickedImage != null) {
      final title = await _showTitleDialog(
          // ignore: use_build_context_synchronously
          context, null); // Pass null to indicate adding a new item
      if (title != null) {
        setState(() {
          _workItems.add(WorkItem(imagePath: pickedImage, title: title));
        });
      }
    }
  }

  Future<String?> _showTitleDialog(
      BuildContext context, WorkItem? workItem) async {
    String? title;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(workItem == null ? 'Enter Title' : 'Edit Title'),
        content: TextField(
          onChanged: (value) {
            title = value;
          },
          controller: TextEditingController(text: workItem?.title),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, title); // Pass title back to the caller
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return title;
  }

  Future<String?> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    return pickedFile?.path;
  }
}

class WorkItem {
  final String imagePath;
  final String title;

  WorkItem({required this.imagePath, required this.title});
}