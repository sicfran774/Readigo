import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static Future<void> adduser(String? username,String email)async{
    CollectionReference users= FirebaseFirestore.instance.collection("users");
    try {
      final newFriendCode = await generateUniqueFriendCode();
      DocumentSnapshot docRef=await users.doc(newFriendCode).get();
      if(!docRef.exists) {
        users.doc(email).set({
          "username": username,
          "email": email,
          "dateCreated": FieldValue.serverTimestamp(),
          "books": [],
          "level": 1,
          "friends": [],
          "bio": "Welcome to my profile!",
        });
      }
    } catch (e) {
      throw Exception("Error adding new user to Firestore: $e");
    }

  }

  static String generateFriendCode([int length = 5]) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  static Future<String> generateUniqueFriendCode() async {
    final users = FirebaseFirestore.instance.collection('users');
    String code;
    bool exists;

    do {
      code = generateFriendCode(); // your existing random 5-digit generator
      final doc = await users.doc(code).get();
      exists = doc.exists;
    } while (exists);

    return code;
  }

  static Future<String?> getCurrentUserFriendCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null; // Not signed in

    final users = FirebaseFirestore.instance.collection('users');

    final snapshot = await users.where('email', isEqualTo: user.email).limit(1).get();

    if (snapshot.docs.isEmpty) return null; // No user found

    return snapshot.docs.first.id;
  }

  static Future<Map<String, dynamic>> getUserData(String friendCode) async {
    try {
      DocumentReference doc=FirebaseFirestore.instance.collection("users").doc(friendCode);//get users data in firebase
      final userData = await doc.get() as Map<String, dynamic>;
      return userData;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<List<dynamic>> getUserBooks(String friendCode)async{
    try {
      final userData = await getUserData(friendCode);
      final books=userData["books"]as List<dynamic>;
      return books;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }


}