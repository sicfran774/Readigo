import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/books/bookscreen.dart';
import 'package:testapp3/friends/friends.dart';
import 'package:testapp3/profile/profile.dart';
import 'package:testapp3/quiz/generate_quiz.dart';
import 'package:testapp3/util/firebase_utils.dart';

import 'gradebook.dart';

class homepage extends StatefulWidget {
  final int initialpage;
  const homepage({super.key,required this.initialpage});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Widget> pages=[];

  late int selectedpage=widget.initialpage;
  void onItemTap(int index){
    setState(() {
      selectedpage=index;
    });
  }

  Future<void> loadPages() async{
    String? currentUserFriendCode = await FirebaseUtils.getCurrentUserFriendCode();

    if (currentUserFriendCode != null) {
      setState(() {
        pages=[
          generatequizscreen(),
          friendspage(),
          bookscreen(),
          ProfileScreen(friendCode: currentUserFriendCode),
        ];
      });
    } else {
      throw Exception("Failed to load profile");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Readigo",
              style: TextStyle(
                fontSize: 36,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(color: Colors.greenAccent,offset: Offset(3, 3),blurRadius: 15)]
              ),
            ),
            Image.asset(height: 87,"assets/images/ReadigoLogo.png")

          ],
        ),
      ),
      bottomNavigationBar: (pages.isEmpty) ? null :
        BottomNavigationBar(
        backgroundColor: Colors.grey,selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.teal,
        currentIndex: selectedpage,
          onTap: onItemTap,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.quiz),label: "quiz"),
            BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined),label: "friends"),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book),label: "books"),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: "profile")
          ]
      ),
      body: Center(
        child: Container(
          child: (pages.isEmpty) ? CircularProgressIndicator() : pages[selectedpage],
        ),
      ),
    );
  }
}
