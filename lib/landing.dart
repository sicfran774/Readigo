import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/CreateAccount.dart';
import 'package:testapp3/LogInPage.dart';
import 'package:testapp3/get_started.dart';
import 'package:testapp3/homepage.dart';
import 'package:testapp3/util/google_services.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 165),
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Text(
                "Welcome to \nBookfania! 📚",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.greenAccent,
                      offset: Offset(3, 3),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: Icon(Icons.email, color: CupertinoColors.activeBlue),
              label: SizedBox(height: 20, child: Text("Sign in with email")),
              style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFFC0FFC0),
                foregroundColor: Color(0xFF41BF41),
              ),
            ),
            // OutlinedButton.icon(
            //   onPressed: () async {
            //     bool success = await GoogleServices.signInWithGoogle();
            //     if (success) {
            //       ScaffoldMessenger.of(
            //         context,
            //       ).showSnackBar(SnackBar(content: Text('Logged in!')));
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(builder: (context) => start_page()),
            //       );
            //     }
            //   },
            //   icon: Container(
            //     width: 20,
            //     height: 30,
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: NetworkImage(
            //           "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png",
            //         ),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            //   label: Text("Sign in with Google"),
            //   style: OutlinedButton.styleFrom(
            //     backgroundColor: Color(0xFFC0FFC0),
            //     foregroundColor: Color(0xFF41BF41),
            //   ),
            // ),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>homepage(initialpage: 2,)),
                );
              },
              icon: Container(
                width: 20,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://www.pngkey.com/png/full/443-4439204_anonymous-icons-download-for-free-in-png-and.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              label: Text("Anonymous Sign In"),
              style: OutlinedButton.styleFrom(
                backgroundColor: Color(0xFFC0FFC0),
                foregroundColor: Color(0xFF41BF41),
              ),
            ),

            SizedBox(height: 1),
            Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Createaccount()),
                );
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size.zero),
                // Removes default minimum size
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                // Removes default padding
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text("Tap Here!", style: TextStyle(color: Colors.cyan)),
            ),
            Image.asset(height: 300, "assets/images/BookfaniaLogo.png"),
          ],
        ),
      ),
    );
  }
}
