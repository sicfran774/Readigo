import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/books/bookscreen.dart';
import 'package:testapp3/friends/friends.dart';
import 'package:testapp3/landing.dart';
import 'package:testapp3/profile/profile.dart';
import 'package:testapp3/quiz/generate_quiz.dart';
import 'package:testapp3/util/firebase_utils.dart';

class homepage extends StatefulWidget {
  final int initialpage;

  const homepage({super.key, required this.initialpage});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Widget> pages = [];

  late int selectedpage = widget.initialpage;

  void onItemTap(int index) {

    if ((index == 0 || index == 1 || index == 3) &&
        FirebaseAuth.instance.currentUser == null) {
      showLoginAlert();
      return;
    }
    setState(() {
      selectedpage = index;
    });
  }

  Future<void> loadPages() async {
    String? currentUserFriendCode =
        await FirebaseUtils.getCurrentUserFriendCode();

    if (currentUserFriendCode != null) {
      setState(() {
        pages = [
          generatequizscreen(),
          FriendsPage(friendCode: currentUserFriendCode),
          bookscreen(),
          ProfileScreen(friendCode: currentUserFriendCode),
        ];
      });
    } else {
      // Handle the case where the friend code is null
      // For example, you might want to show an error message or a default page
      setState(() {
        pages = [
          Center(child: Text("Please log in to access the quiz page")),
          Center(child: Text("Please log in to access the friends page")),
          bookscreen(),
          Center(child: Text("Please log in to access the profile page")),
        ];
      });
    }
  }

  // Show alert dialog to LOGIN if friend code is null
  void showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Required"),
          content: Text("Please log in to access this feature."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // go to start page
            TextButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LandingPage()),
                );
              },
            ),
          ],
        );
      },
    );
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
        centerTitle: true, // ensures title stays centered
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bookfania",
              style: TextStyle(
                fontSize: 36,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.greenAccent,
                    offset: Offset(3, 3),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Image.asset("assets/images/BookfaniaLogo.png", height: 87),
          ],
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LandingPage()),
                );
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar:
          (pages.isEmpty)
              ? null
              : BottomNavigationBar(
                backgroundColor: Colors.grey,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.teal,
                currentIndex: selectedpage,
                onTap: onItemTap,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.quiz),
                    label: "quiz",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined),
                    label: "friends",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    label: "books",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "profile",
                  ),
                ],
              ),
      body: Center(
        child: Container(
          child:
              (pages.isEmpty)
                  ? CircularProgressIndicator()
                  : pages[selectedpage],
        ),
      ),
    );
  }
}
