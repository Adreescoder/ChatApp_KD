import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedHeader(),
            AboutSection(),
            SkillsSection(),
            ProjectsSection(),
            ContactSection(),
          ],
        ),
      ),
    );
  }
}

class AnimatedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, I'm", style: TextStyle(color: Colors.white, fontSize: 24)),
              Text("Muhammad Adrees Nazir", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Flutter Developer | UI/UX Designer", style: TextStyle(color: Colors.white70, fontSize: 18)),
            ],
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0,
          child: Image.asset('assets/img.png', height: 250),
        )
      ],
    );
  }
}

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Me", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("I'm a passionate Flutter developer with experience in building modern, responsive, and scalable applications for web and mobile platforms."),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Skills", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: ["Flutter", "Dart", "Firebase", "UI/UX", "GetX"].map((skill) {
              return Chip(label: Text(skill));
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Projects", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ProjectCard(title: "E-Commerce App", description: "A full-featured online shopping app."),
          ProjectCard(title: "Chat App", description: "Real-time messaging with Firebase."),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;

  ProjectCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Me", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, color: Colors.purple),
              SizedBox(width: 10),
              Text("adreesnazir@gmail.com"),
            ],
          ),
        ],
      ),
    );
  }
}


/// Master code you`