import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

// Authentication Logic
class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'profilePic': '',
        'isOnline': true,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _firestore.collection('users').doc(_auth.currentUser!.uid).update({'isOnline': true});
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void signOut() async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({'isOnline': false});
    await _auth.signOut();
  }
}

// Authentication Wrapper
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.hasData ? HomeScreen() : AuthScreen();
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// Authentication Screen
class AuthScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(hintText: 'Name')),
            TextField(controller: emailController, decoration: InputDecoration(hintText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(hintText: 'Password'), obscureText: true),
            ElevatedButton(
                onPressed: () => authController.signUp(emailController.text, passwordController.text, nameController.text),
                child: Text('Sign Up')),
            ElevatedButton(
                onPressed: () => authController.signIn(emailController.text, passwordController.text),
                child: Text('Login')),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users'), actions: [
        IconButton(onPressed: authController.signOut, icon: Icon(Icons.logout)),
      ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['isOnline'] ? 'Online' : 'Offline'),
                onTap: () => Get.toNamed(
                  '/chat',
                  arguments: {
                    'userId': user.id,
                    'userName': user['name'],
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Chat Screen with Voice Feature
class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  ChatScreen({required this.userId, required this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  late FlutterSoundRecorder recorder;
  late FlutterSoundPlayer player;
  bool isRecording = false;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    player = FlutterSoundPlayer();
    _initSound();
  }

  Future<void> _initSound() async{
    await recorder.openRecorder(codec: Codec.opusWebM).then((value) {
      if(value!=null){
        print("recorder initialized");
      }
    });
    await player.openPlayer().then((value) {
      if(value!=null){
        print("player initialized");
      }
    });
  }
  String _getChatRoomId() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (currentUserId.hashCode <= widget.userId.hashCode){
      return '$currentUserId-${widget.userId}';
    }
    return '${widget.userId}-$currentUserId';
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(_getChatRoomId())
          .collection('messages')
          .add({
        'text': messageController.text,
        'voice': null,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'receiver': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  void recordVoice() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      if(recorder.isStopped){
        await recorder.openRecorder(codec: Codec.opusWebM).then((value) {
          if(value!=null){
            print("recorder re-initialized");
          }
        });
      }

      if (!isRecording) {
        _recordingPath = 'voice_${DateTime.now().millisecondsSinceEpoch}.mp4';

        await recorder.startRecorder(
          toFile: _recordingPath,
          codec: Codec.opusWebM,
        );
        setState(() {
          isRecording = true;
        });
      } else {
        String? path = await recorder.stopRecorder();
        setState(() {
          isRecording = false;
        });
        if(path!=null){
          File file = File(path);
          UploadTask task = FirebaseStorage.instance
              .ref('voices/${DateTime.now().millisecondsSinceEpoch}.mp4')
              .putFile(file);
          TaskSnapshot snapshot = await task;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          FirebaseFirestore.instance
              .collection('chatRooms')
              .doc(_getChatRoomId())
              .collection('messages').add({
            'text': null,
            'voice': downloadUrl,
            'sender': FirebaseAuth.instance.currentUser!.uid,
            'receiver': widget.userId,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    }
    else {
      Get.snackbar('Permission Denied', 'Microphone permission is required');
    }
  }

  void playVoice(String url) async {
    if(player.isStopped){
      await player.openPlayer().then((value) {
        if(value!=null){
          print("player re-initialized");
        }
      });
    }
    await player.startPlayer(fromURI: url);
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(_getChatRoomId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool isMe = msg['sender'] == FirebaseAuth.instance.currentUser!.uid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: msg['text'] != null
                            ? Text(msg['text'], style: TextStyle(fontSize: 16))
                            : msg['voice'] != null
                            ? IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            playVoice(msg['voice']);
                          },
                        )
                            : SizedBox.shrink(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: messageController, decoration: InputDecoration(hintText: 'Type a message'))),
              IconButton(icon: Icon(Icons.mic), onPressed: recordVoice),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: ()=> FirebaseInitializer() ),
      GetPage(
          name: '/chat',
          page: () {
            final arguments = Get.arguments as Map<String, dynamic>?;
            return ChatScreen(
              userId: arguments?['userId'] ?? '', // Use a default value if 'userId' is missing
              userName: arguments?['userName'] ?? '', // Use a default value if 'userName' is missing
            );
          }
      ),
    ],
  )
  );
}

// Firebase Initializer
class FirebaseInitializer extends StatefulWidget {
  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try{
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    }catch(e){
      print("firebase initialization error");
    }

  }

  @override
  Widget build(BuildContext context) {
    if(!_initialized){
      return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          )
      );
    }else{
      return AuthWrapper();
    }
  }
}