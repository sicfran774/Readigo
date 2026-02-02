import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp3/LogInPage.dart';
import 'package:testapp3/util/firebase_utils.dart';
import 'package:testapp3/util/google_services.dart';

import 'get_started.dart';
import 'LogInPage.dart';

class Createaccount extends StatefulWidget {
  const Createaccount({super.key});

  @override
  State<Createaccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<Createaccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> createNewaccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
// <<<<<<< HEAD
//       await GoogleServices.adduser(username, email);
//
//       // Show success message and navigate
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Account created successfully!'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => start_page()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       print('Error: ${e.code} - ${e.message}');
//
//       // Show error message to user
//       String errorMessage = 'Account creation failed. Please try again.';
//       if (e.code == 'weak-password') {
//         errorMessage = 'Password is too weak. Use at least 6 characters.';
//       } else if (e.code == 'email-already-in-use') {
//         errorMessage = 'An account already exists with this email.';
//       } else if (e.code == 'invalid-email') {
//         errorMessage = 'Invalid email address.';
//       }
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
// =======
      if(await FirebaseUtils.adduser(username, email)){
        if(mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
        }
      }
    } on FirebaseAuthException catch (e) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blueAccent,
// >>>>>>> bedd4df4090b853eb7aec16896d42ea8e7168282
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Account",
          style: TextStyle(fontSize: 25, fontFamily: "Voltaire"),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 360,
                  child: Column(
                    children: [
                      Align(
                        child: Text("Email", style: TextStyle()),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: emailController,
            
                          decoration: const InputDecoration(
                            helperText: "",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            hintText: '',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Type in your Email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  child: Column(
                    children: [
                      Align(
                        child: Text("Username", style: TextStyle()),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            helperText: "",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            hintText: '',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please type a Username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  child: Column(
                    children: [
                      Align(
                        child: Text("Password", style: TextStyle()),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            helperText: "",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            hintText: '',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Type your Password Again';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 360,
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          "Enter your Password again",
                          style: TextStyle(),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            helperText: "",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            hintText: '',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Type your Password Again';
                            } else if (value != passwordController.text) {
                              return "The Passwords do not Match";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        await createNewaccount();
                      }
                    },
                    label: Text("Submit"),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFC0FFC0),
                      foregroundColor: Color(0xFF41BF41),
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
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
                SizedBox(height: 20),
                Image.asset(height: 300, "assets/images/BookfaniaLogo.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
