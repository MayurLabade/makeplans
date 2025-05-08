import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import '../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveFirebaseUser(User user) async {
    try {
      final uri = Uri.parse('https://c3a0-106-195-9-43.ngrok-free.app/makeplans-api/api/auth/save_firebase_user.php');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "firebase_uid": user.uid,
          "name": user.displayName ?? _nameController.text,
          "email": user.email ?? '',
          "profile_picture": user.photoURL ?? ''
        }),
      );

      final result = jsonDecode(response.body);
      if (result['status'] == true) {
        print("✅ MySQL user sync success: ${result['user_id']}");
      } else {
        print("⚠️ MySQL sync failed: ${result['message']}");
      }
    } catch (e) {
      print("❌ Error syncing with MySQL: $e");
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final methods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(_emailController.text);
        if (methods.isNotEmpty) {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'This email is already registered. Please login instead.',
          );
        }

        await AuthService().register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await _saveFirebaseUser(user);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration failed. Please try again.';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already registered. Please login instead.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak.';
        } else if (e.message != null) {
          errorMessage = e.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget themedInput(InputField child) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIconColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              themedInput(InputField(
                controller: _nameController,
                labelText: 'Name',
                icon: Icons.person,
                validator: (value) =>
                value!.isEmpty ? 'Please enter your name' : null,
              )),
              const SizedBox(height: 16),
              themedInput(InputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
                validator: (value) =>
                !RegExp(Constants.emailRegex).hasMatch(value!)
                    ? 'Enter a valid email'
                    : null,
              )),
              const SizedBox(height: 16),
              themedInput(InputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) =>
                value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              )),
              const SizedBox(height: 16),
              themedInput(InputField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) =>
                value != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
              )),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                text: 'Register',
                onPressed: _register,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Already have an account? Login here',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
