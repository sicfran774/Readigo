import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/friends/add_friend.dart';
import 'package:testapp3/util/firebase_utils.dart';

import 'friend_tile.dart';

class ChatFriendPage extends StatefulWidget {
  final String friendCode;

  const ChatFriendPage({super.key, required this.friendCode});

  @override
  State<ChatFriendPage> createState() => _ChatFriendPageState();
}

class _ChatFriendPageState extends State<ChatFriendPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatID(String code) {
    List<String> friendCodes = [widget.friendCode, code];
    friendCodes.sort();
    return friendCodes.join("_");

  }
  Future <String> getLastMessage(String ChatID)async{
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("chat")
        .doc(ChatID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['text'] ?? "";
    } else {
      return "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddFriendPage()));
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 21,
            ),
            Text("Chats",style: TextStyle(fontSize: 35,fontFamily: "Voltaire"),),
            SizedBox(height: 5,),
            Expanded(
              child: FutureBuilder(
                  future: FirebaseUtils.getUserFriends(widget.friendCode),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No friends :("));
                    }
                    final userFriends = snapshot.data!;

                    return ListView.builder(
                      itemCount: userFriends.length,
                      itemBuilder: (context, index) {
                        final friendCode = userFriends[index];
                        return FutureBuilder(
                            future: FirebaseUtils.getUserData(friendCode),
                            builder: (context, asyncSnapshot) {
                              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              final friend = asyncSnapshot.data!;
                              return FutureBuilder(
                                  future: getLastMessage(getChatID(friend["friendCode"])),
                                  builder: (context, asyncSnapshot) {
                                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    final message = asyncSnapshot.data!;

                                    return FriendTile(
                                        profilePic: friend["profilePic"],
                                        info: message,
                                        chat: true,
                                        friendCode: friend["friendCode"],
                                        username: friend["username"]);
                                  }
                              );

                            }
                        );
                      },
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
