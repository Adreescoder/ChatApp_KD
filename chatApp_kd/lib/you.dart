import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 80,
            color: Colors.black,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.home, color: Colors.white, size: 30),
                Icon(Icons.explore, color: Colors.white, size: 30),
                Icon(Icons.video_library, color: Colors.white, size: 30),
                Icon(Icons.settings, color: Colors.white, size: 30),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, color: Colors.white),
                              hintText: "Search",
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blueAccent.withOpacity(0.5),
                          ),
                          child: const Text("Sign Up"),
                        ),
              
                      ],
                    ),
                  ),
              
                  // Category Filters
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (String category in ["All", "Music", "Learning", "Films", "News", "Sports"])
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Chip(
                                label: Text(category, style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.grey[800],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height, // Full height of the screen
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Determine the number of columns based on screen width
                          int crossAxisCount = constraints.maxWidth < 600 ? 1 : 3; // 1 column for mobile, 3 for larger screens

                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[900],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          "assets/img.png",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Video Title $index",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                                      child: Text(
                                        "Channel Name",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )



                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//// meri yad