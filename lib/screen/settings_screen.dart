import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? profileImagePath;
  User? _firebaseUser;
  bool _notificationsEnabled = false;

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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Help"),
        content: const Text("If you need help, please contact support@makeplans.app"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("About"),
        content: const Text("MakePlans App\nVersion 1.0.0\n© 2025 MakePlans Inc."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Change Password"),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "New Password"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              if (_firebaseUser != null && _passwordController.text.isNotEmpty) {
                await _firebaseUser!.updatePassword(_passwordController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Password updated successfully")),
                );
              }
            },
            child: const Text("Update", style: TextStyle(color: Colors.cyan)),
          )
        ],
      ),
    );
  }

  Future<void> _generateInvoice() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text("Invoice for ${_firebaseUser?.displayName ?? "Guest"}"),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _exportProfileAsPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("User Profile", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 16),
                pw.Text("👤 Name: ${_firebaseUser?.displayName ?? "Not set"}"),
                pw.Text("📧 Email: ${_firebaseUser?.email ?? "Not available"}"),
                pw.Text("🕒 Exported on: ${DateTime.now()}"),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // Close the app
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.cyan),
              onPressed: _exportProfileAsPDF,
              tooltip: "Export Profile",
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.cyan),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                color: Colors.cyan[800],
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.campaign, color: Colors.white),
                  title: const Text("🎉 Invite friends and earn rewards!",
                      style: TextStyle(color: Colors.white)),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming soon!"))),
                ),
              ),
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
              Text(
                "${greeting()}, ${_firebaseUser?.displayName ?? 'Guest'} 👋",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                _firebaseUser?.email ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text("Change Password", style: TextStyle(color: Colors.white)),
                onTap: _showChangePasswordDialog,
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.white),
                title: const Text("Download Invoice PDF", style: TextStyle(color: Colors.white)),
                onTap: _generateInvoice,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "🔍 Smart Suggestion: You booked Goa last time, explore new spots this summer!",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.white),
                title: const Text("Help", style: TextStyle(color: Colors.white)),
                onTap: _showHelpDialog,
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text("About", style: TextStyle(color: Colors.white)),
                onTap: _showAboutDialog,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content: const Text("Are you sure you want to logout from this account?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            },
                            child: const Text("Logout", style: TextStyle(color: Colors.cyan)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.cyan),
                  label: const Text("Logout", style: TextStyle(fontSize: 16, color: Colors.cyan)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
      ),
    );
  }
}
