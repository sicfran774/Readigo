import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/util/firebase_utils.dart';

class ChatPage extends StatefulWidget {
  final String friendCode;

  const ChatPage({super.key, required this.friendCode});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = true;
  late String ownFriendCode;
  late String chatId;
  late Map<String, dynamic> friendInfo;

  void initVar() async{
    ownFriendCode = (await FirebaseUtils.getCurrentUserFriendCode())!;
    List<String> friendCodes = [widget.friendCode, ownFriendCode];
    friendCodes.sort();
    chatId = friendCodes.join("_");

    friendInfo = (await FirebaseUtils.getUserData(widget.friendCode))!;
    
    setState(() {
      isLoading = false;
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    String msg = _messageController.text.trim();
    _messageController.clear();

    await _firestore.collection('chat').doc(chatId).collection('messages').add(
        {
          'senderId': ownFriendCode,
          'receiverId': widget.friendCode,
          'text': msg,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  @override
  void initState() {
    super.initState();
    initVar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (!isLoading) ? Text("${friendInfo["username"]}") : CircularProgressIndicator(),
      ),
      body: (isLoading) ? CircularProgressIndicator() : Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chat')
                      .doc(chatId)
                      .collection('messages').orderBy('timestamp',descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        bool isMe = data['senderId'] == ownFriendCode;
                        return _buildMessageBubble(data['text'], isMe);
                      },
                    );
                  },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(49)
                      ),
                      
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
