import 'package:flutter/material.dart';
import 'package:testapp3/homepage.dart';

class start_page extends StatefulWidget {
  const start_page({super.key});

  @override
  State<start_page> createState() => _start_pageState();
}

class _start_pageState extends State<start_page> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height*0.05,),
              Container(
                  padding:EdgeInsets.all(65),
                  decoration:BoxDecoration(border: Border.all(color: Colors.white),),
                  child: Text(
                    "Welcome to \nBookfania! 📚",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize:48,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.greenAccent,offset: Offset(3, 3),blurRadius: 15)]),)
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>homepage(initialpage: 2,)));
                  },
                  child: Container(
                      child: Center(child: Text(
                          "Tap here to get \nreading",
                        style: TextStyle(color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Redressed"),
                        textAlign: TextAlign.center,
                      )),
                    width: 199, height: 80,
                  ),
                style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFFC0FFC0),
                    foregroundColor: Color(0xFF41BF41)
                ),
              ),
              Image.asset(height: 300,"assets/images/BookfaniaLogo.png")
            ],
          ),
        ),
      ),
    );
  }
}
