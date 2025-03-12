import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for saving video links
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';

class UploadVideoScreen extends StatefulWidget {
  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false; // Upload progress indicator

  Future<void> pickAndUploadVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    setState(() {
      _isUploading = true;
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child("videos/$fileName.mp4");

    UploadTask uploadTask;
    if (kIsWeb) {
      Uint8List bytes = await video.readAsBytes();
      uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'video/mp4'));
    } else {
      File file = File(video.path);
      uploadTask = ref.putFile(file);
    }

    // Progress Indicator Listener
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      print("Upload Progress: $progress %");
    });

    // Wait for Upload to Complete
    await uploadTask.whenComplete(() async {
      String downloadURL = await ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance.collection('videos').add({
        'videoUrl': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
      });

      Get.to(() => VideoListScreen()); // Show all videos
    }).catchError((error) {
      setState(() {
        _isUploading = false;
      });
      print("Upload failed: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video")),
      body: Center(
        child: _isUploading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Uploading video, please wait..."),
          ],
        )
            : ElevatedButton(
          onPressed: pickAndUploadVideo,
          child: Text("Pick Video & Upload"),
        ),
      ),
    );
  }
}

// 📌 **Screen to Show List of Videos (YouTube Style)**
class VideoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Videos")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('videos').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Videos Available"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              String videoUrl = doc['videoUrl'];

              return ListTile(
                leading: Icon(Icons.video_library, size: 40, color: Colors.red),
                title: Text("Video"),
                subtitle: Text(videoUrl),
                onTap: () => Get.to(() => VideoStreamScreen(videoUrl: videoUrl)),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// 📌 **Screen to Play Video**
class VideoStreamScreen extends StatefulWidget {
  final String videoUrl;
  VideoStreamScreen({required this.videoUrl});

  @override
  _VideoStreamScreenState createState() => _VideoStreamScreenState();
}

class _VideoStreamScreenState extends State<VideoStreamScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update UI
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Play Video")),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

// videos main
// videos main
// videos main