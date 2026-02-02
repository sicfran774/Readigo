import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp3/books/Review.dart';
import 'package:testapp3/books/book_provider.dart';
import 'package:testapp3/util/openai_prompt.dart';
import 'package:url_launcher/url_launcher.dart';

import '../homepage.dart';
import '../landing.dart';
import 'book.dart';

class BookPreview extends StatefulWidget {
  final String bookImageurl;
  final String title;
  final String author;
  final int pages;
  final String grade;
  final String shopurl;
  final bool review;
  final int rating;
  final String ReviewText;

  const BookPreview({
    super.key,
    required this.bookImageurl,
    required this.title,
    required this.author,
    required this.pages,
    required this.grade,
    required this.shopurl,
    this.review = false,
    this.rating = 0,
    this.ReviewText = "",
  });

  @override
  State<BookPreview> createState() => _BookPreviewState();
}

class _BookPreviewState extends State<BookPreview> {
  int gradeLevel = -1;

  User? currentUser = FirebaseAuth.instance.currentUser;

  void getGradeLevel() async {
    try {
      final futureGradeLevel = await OpenaiPrompt.getBookGradeLevel(widget.title);
      setState(() {
        gradeLevel = futureGradeLevel;
      });
    } catch (e) {
      setState(() {
        gradeLevel = -2; // Error state
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGradeLevel();
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
  Widget build(BuildContext context) {
    final bookprovider = context.read<BookProvider>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Image.asset(height: 87, "assets/images/BookfaniaLogo.png"),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, fontFamily: "Voltaire"),
            ),
            Text(
              widget.author,
              style: TextStyle(fontSize: 20, fontFamily: "Voltaire"),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 50,
                    child: widget.bookImageurl.isNotEmpty
                        ? Image.network(widget.bookImageurl)
                        : Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.menu_book, size: 60, color: Colors.grey[600]),
                                SizedBox(height: 8),
                                Text("No Cover", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 50,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            widget.pages.toString() + " pages",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: "Voltaire",
                            ),
                          ),
                          //Text((int.parse(widget.pages)*300).toString()+" words",style: TextStyle(fontSize: 30,fontFamily: "Voltaire"),),
                          (gradeLevel == -1)
                              ? CircularProgressIndicator()
                              : (gradeLevel == -2)
                                  ? Text(
                                    "Grade Level: N/A",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Voltaire",
                                      color: Colors.grey,
                                    ),
                                  )
                                  : Text(
                                    "Grade Level: $gradeLevel",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: "Voltaire",
                                    ),
                                  ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (widget.review)
                ? ReviewWidget(Review: widget.ReviewText, rating: widget.rating)
                : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final Uri Url = Uri.parse(widget.shopurl);
                        if (!await launchUrl(Url)) {
                          throw Exception("cannot open url");
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFFEBFFEE),
                        foregroundColor: Color(0xFF41BF41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: 120,
                        height: 50,
                        child: Center(
                          child: Text(
                            "📖Read it",
                            style: TextStyle(
                              color: Color(0xFF00C8B3),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (currentUser == null) {
                          showLoginAlert();
                          return;
                        }
                        bookprovider.setBook(
                          Book(
                            title: widget.title,
                            authors: [widget.author],
                            pageCount: widget.pages,
                            thumbnailUrl: widget.bookImageurl,
                            shopurl: widget.shopurl,
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => homepage(initialpage: 0),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFFEBFFEE),
                        foregroundColor: Color(0xFF41BF41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: 174,
                        height: 50,
                        child: Center(
                          child: Text(
                            "📝Quiz Me❓❓❓",
                            style: TextStyle(
                              color: Color(0xFF00C8B3),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (currentUser == null) {
                          showLoginAlert();
                          return;
                        }
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BookReviewPage(
                                  title: widget.title,
                                  author: widget.author,
                                  imageurl: widget.bookImageurl,
                                  pages: widget.pages,
                                ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFFEBFFEE),
                        foregroundColor: Color(0xFF41BF41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Container(
                        width: 152,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Add to Library📚",
                            style: TextStyle(
                              color: Color(0xFF00C8B3),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final String Review;
  final int rating;

  const ReviewWidget({super.key, required this.Review, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0x8cf2f2f7),
      ),
      width: 350,
      child: Column(
        children: [
          Text("Review", style: TextStyle(fontSize: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              rating,
              (index) => Icon(Icons.star, size: 60, color: Colors.yellow),
            ),
          ),
          Text(Review, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
