import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? profileImagePath;
  User? _firebaseUser;
  bool _notificationsEnabled = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _firebaseUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImagePath = prefs.getString('profile_image');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyan),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView to handle overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!))
                          : _firebaseUser?.photoURL != null
                          ? NetworkImage(_firebaseUser!.photoURL!)
                          : const AssetImage("assets/images/user_avatar.png")
                      as ImageProvider,
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Greeting Text
            Text(
              "${greeting()}, ${_firebaseUser?.displayName ?? 'Guest'} 👋",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Display Name and Email (only show once)
            if (_firebaseUser != null) ...[
              Text(
                _firebaseUser!.displayName ?? 'Guest User',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                _firebaseUser!.email ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
            ],
            const Divider(color: Colors.white),
            // Account Settings Section
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: const Text("Change Password", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/change_password');
              },
            ),
            const SizedBox(height: 15),
            // App Preferences Section
            ExpansionTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("App Preferences", style: TextStyle(color: Colors.white)),
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.white),
                  title: const Text("Language", style: TextStyle(color: Colors.white)),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: Colors.black,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                    items: <String>['English', 'Spanish', 'French', 'German']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.white),
                  title: const Text("Enable Notifications", style: TextStyle(color: Colors.white)),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: Colors.cyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white),
            // Help and About Section
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text("Help", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text("About", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            const SizedBox(height: 30),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false),
                icon: const Icon(Icons.logout, color: Colors.cyan),
                label: const Text("Logout", style: TextStyle(fontSize: 16, color: Colors.cyan)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm Deletion"),
                      content: const Text(
                          "Are you sure you want to delete your account? This action cannot be undone."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Text("Delete", style: TextStyle(color: Colors.cyan)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Delete Account",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
