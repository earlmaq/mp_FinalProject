import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? firstNameError;
  String? lastNameError;

  void registerUser(BuildContext context) async {
    setState(() {
      emailError = null;
      passwordError = null;
      firstNameError = null;
      lastNameError = null;
    });

    bool isValid = true;

    // Check if the fields are empty
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email cannot be empty';
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password cannot be empty';
      });
      isValid = false;
    }
    if (firstNameController.text.isEmpty) {
      setState(() {
        firstNameError = 'First name cannot be empty';
      });
      isValid = false;
    }

    if (lastNameController.text.isEmpty) {
      setState(() {
        lastNameError = 'Last name cannot be empty';
      });
      isValid = false;
    }

    // If any field is invalid, stop execution
    if (!isValid) {
      return;
    }

    try {
      // Register the user with FirebaseAuth
      UserCredential userInfo = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userInfo.user;

      if (user != null) {
        // Reference to the Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Add the data to the Firestore in the customer collection
        await firestore.collection('customers').doc(user.uid).set({
          'customerId': user.uid,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
        });

        print('Registration and Firestore Save Successful');
      }

      // Navigate back to the login screen
      Navigator.pop(context); // Pops the registration screen and navigates back to login screen
    } catch (e) {
      print('Registration Failed: $e');
      String errorMessage = 'An unknown error occurred.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'Something went wrong. Please try again.';
        }
      }

      // Show the error message next to the respective TextField
      setState(() {
        if (e is FirebaseAuthException) {
          if (e.code == 'invalid-email' || e.code == 'email-already-in-use') {
            emailError = errorMessage;
          } else if (e.code == 'weak-password') {
            passwordError = errorMessage;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                errorText: firstNameError,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                errorText: lastNameError,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: emailError,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordError,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
