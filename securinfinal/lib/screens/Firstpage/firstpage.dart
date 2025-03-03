import 'package:flutter/material.dart';
import 'package:securinfinal/screens/createaccount/createaccount.dart';
import 'package:securinfinal/screens/welcomeback/welcomeback.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000435), // Dark background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Move content to the bottom
        children: [
          // SecureInk Text & Tagline (Positioned further left)
          Padding(
            padding: const EdgeInsets.only(right: 200, bottom: 30), // Moved further to the left
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SecureIn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Justice, Secured. Truth, Unshakable.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Login and Signup Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the existing Welcomeback page when login button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Welcomeback()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    // Navigate to the CreateAccount page when sign up button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccountPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}