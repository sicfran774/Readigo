import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/books/book_tile.dart';

import '../util/firebase_utils.dart';

class ProfileScreen extends StatefulWidget {
  final String friendCode;

  const ProfileScreen({super.key, required this.friendCode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            Container(
              height:250 , width: 333,
              margin: EdgeInsets.only(top: 35, bottom:30),
              padding: EdgeInsets.all(0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xfff2f2f7)
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage('https://imgcdn.stablediffusionweb.com/2024/4/15/437c2a91-01ea-4d6b-b7c4-d489155207f7.jpg'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("DOGGGG",style: TextStyle(fontSize: 20,fontFamily: "Voltaire"),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 27,),
                              Text("#42942",style: TextStyle(fontSize: 18,fontFamily: "Voltaire"),),
                              IconButton(onPressed: (){}, icon: Icon(Icons.copy))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(

                    ),
                    flex: 3,
                  ),
                  Expanded(
                    flex: 35,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("20 Books \nRead",style: TextStyle(height:1.2,fontSize: 30,fontFamily: "Voltaire"),),
                          SizedBox(height: 7,),
                          Text("Level 3",style: TextStyle(fontSize: 30,fontFamily: "Voltaire",fontWeight: FontWeight.bold),),
                          TextButton(
                              onPressed: (){
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(Size.zero), // Removes default minimum size
                                padding: WidgetStateProperty.all(EdgeInsets.zero), // Removes default padding
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text("20 followers",style: TextStyle(color: Color(0xff0088FF)),)
                          ),
                          TextButton(
                              onPressed: (){
                              },
                              style: ButtonStyle(
                                minimumSize: WidgetStateProperty.all(Size.zero), // Removes default minimum size
                                padding: WidgetStateProperty.all(EdgeInsets.zero), // Removes default padding
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text("20 following",style: TextStyle(color: Color(0xff0088FF)),)
                          ),
                          Text("This is my bio",style: TextStyle(fontSize: 18,fontFamily: "Voltaire"),),



                        ],
                      ),
                  ),
                  Expanded(
                    flex: 20,
                    child: Center(
                      child: Column(
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.mode_edit_outlined))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: FirebaseUtils.getUserBooks(widget.friendCode),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError){
                        return Center(
                            child: Text('Error: ${snapshot.error}')
                        );
                      }

                      final querySnapshot = snapshot.data;
                      if (querySnapshot == null || querySnapshot.isEmpty) {
                        return Center(child: Text("No posts found."));
                      }

                      return ListView.builder(
                        itemCount: querySnapshot.length,
                        itemBuilder: (context, index) {
                          final book=querySnapshot[index];
                          return BookTile(bookImageurl: book["imageurl"], title: book["title"], author: book["author"], pages:100 , shopurl: "shopurl" , grade: '',review: true,rating: book["rating"],ReviewText: book["review"],);
                        },
                      );
                    }
                )
            )
          ],
        ),
      )
    );
  }

}
