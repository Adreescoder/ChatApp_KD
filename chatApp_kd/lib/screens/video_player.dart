import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class UploadVideoScreen extends StatefulWidget {
  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    File file = File(video.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child("videos/$fileName.mp4");
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();

    Get.to(() => VideoStreamScreen(videoUrl: downloadURL));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video")),
      body: Center(
        child: ElevatedButton(
          onPressed: pickAndUploadVideo,
          child: Text("Pick Video & Upload"),
        ),
      ),
    );
  }
}

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
        setState(() {});
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

