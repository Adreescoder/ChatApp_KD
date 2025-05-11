import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  double _progress = 0;
  bool isUploading = false;
  String uploadedUrl = '';

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      uploadFile(file, fileName);
    }
  }

  Future<void> uploadFile(File file, String fileName) async {
    setState(() {
      isUploading = true;
      _progress = 0;
    });

    try {
      Reference storageRef = FirebaseStorage.instance.ref().child("uploads/$fileName");
      UploadTask uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        });
      });

      await uploadTask.whenComplete(() async {
        String downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          uploadedUrl = downloadUrl;
          isUploading = false;
        });
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Files")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isUploading
                ? Column(
              children: [
                CircularProgressIndicator(value: _progress),
                SizedBox(height: 10),
                Text("${(_progress * 100).toInt()}% Uploading..."),
              ],
            )
                : ElevatedButton(
              onPressed: pickAndUploadFile,
              child: Text("Select & Upload File"),
            ),
            if (uploadedUrl.isNotEmpty)
              Text("File Uploaded Successfully!\n$uploadedUrl", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
//// Long time bad come back