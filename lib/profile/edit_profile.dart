import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/firebase_utils.dart';
import '../landing.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String friendCode;

  const EditProfilePage({
    super.key,
    required this.userData,
    required this.friendCode,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String selectedProfilePic;
  bool _saving = false;

  final List<String> profilePicOptions = [
    "https://imgcdn.stablediffusionweb.com/2024/4/15/437c2a91-01ea-4d6b-b7c4-d489155207f7.jpg",
    "https://creator.nightcafe.studio/jobs/kWGLUgAwkj1kLLvcqvJD/kWGLUgAwkj1kLLvcqvJD--1--kgpmj.jpg",
    "https://imgcdn.stablediffusionweb.com/2024/2/23/da8fbab2-4c52-469c-8f91-437b89850f61.jpg",
    "https://creator.nightcafe.studio/jobs/UpYqKstniHmSEMYpoRnA/UpYqKstniHmSEMYpoRnA--3--ahniu.jpg"
  ];

  @override
  void initState() {
    super.initState();

    _usernameController.text = widget.userData["username"] ?? "";
    _bioController.text = widget.userData["bio"] ?? "";
    selectedProfilePic = widget.userData["profilePic"] ?? profilePicOptions.first;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final newData = <String, dynamic>{};

    final newUsername = _usernameController.text.trim();
    final newBio = _bioController.text.trim();

    // Only add fields that changed
    if (newUsername != widget.userData["username"]) {
      newData["username"] = newUsername;
    }
    if (newBio != widget.userData["bio"]) {
      newData["bio"] = newBio;
    }
    if (selectedProfilePic != widget.userData["profilePic"]) {
      newData["profilePic"] = selectedProfilePic;
    }

    if (newData.isNotEmpty) {
      await FirebaseUtils.updateUser(widget.friendCode, newData);
    }

    setState(() => _saving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved!")),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final passwordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text('Please enter your password to confirm:'),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your password')),
                  );
                  return;
                }

                try {
                  // Re-authenticate user before deletion
                  final user = FirebaseAuth.instance.currentUser;
                  final email = user?.email;

                  if (email == null) {
                    throw Exception('No user email found');
                  }

                  final credential = EmailAuthProvider.credential(
                    email: email,
                    password: password,
                  );

                  await user?.reauthenticateWithCredential(credential);

                  // Close the dialog
                  Navigator.of(dialogContext).pop();

                  // Delete the user
                  await FirebaseUtils.deleteUser(widget.friendCode);

                  // Navigate to landing page
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LandingPage()),
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  Navigator.of(dialogContext).pop();

                  String errorMessage = 'Failed to delete account';
                  if (e.code == 'wrong-password') {
                    errorMessage = 'Incorrect password';
                  } else if (e.code == 'requires-recent-login') {
                    errorMessage = 'Please log out and log back in before deleting your account';
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.of(dialogContext).pop();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username cannot be empty';
                  }
                  if (value.length < 3) return 'Minimum 3 characters';
                  if (value.length > 15) return 'Maximum 15 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _bioController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Choose Profile Picture",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: profilePicOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final url = profilePicOptions[index];
                    final isSelected = url == selectedProfilePic;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProfilePic = url;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Danger Zone - Delete Account
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                "Danger Zone",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _showDeleteAccountDialog,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // ▶ SAVE BUTTON AT THE BOTTOM
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveProfile,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Changes"),
            ),
          ),
        ),
      ),
    );
  }
}
