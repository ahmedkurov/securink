import 'package:flutter/material.dart';
import 'package:securinfinal/screens/createaccount/createaccount.dart';

import '../mainscreen.dart';

class Welcomeback extends StatefulWidget {
  const Welcomeback({super.key});

  @override
  _WelcomebackState createState() => _WelcomebackState();
}

class _WelcomebackState extends State<Welcomeback> {
  final _formKey = GlobalKey<FormState>();
  String? selectedUserType;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    if (selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a user type'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  void _handleLogin() {
    if (validateForm()) {
      if (selectedUserType == 'Users') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (selectedUserType == 'Organisations') {
        Navigator.pushReplacementNamed(context, '/govhome'); // Redirect to GovHome
      } else {
        // Handle other user types if necessary
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000435),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Back Button
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Login Form
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to your Account',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const LoginForm(),
                    ],
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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? selectedUserType;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    if (selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a user type'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Role Selection Dropdown
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedUserType,
                hint: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select User Type',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                dropdownColor: const Color(0xFF2A2B3E),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.arrow_drop_down, color: Colors.white70),
                ),
                items: ['Organisations', 'Users']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedUserType = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Username field
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
              hintText: 'User Id',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Password field
          TextField(
            controller: passwordController,
            obscureText: !_isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
              hintText: 'Password',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Remember Me and Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFF00F7B1);
                        }
                        return Colors.white70;
                      },
                    ),
                  ),
                  const Text('Remember me', style: TextStyle(color: Colors.white70)),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (validateForm()) {
                  if (selectedUserType == 'Users') {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => BottomNavBarScreen()),
                    );
                  } else if (selectedUserType == 'Organisations') {
                    Navigator.pushReplacementNamed(context, '/govhome'); // Redirect to GovHome
                  } else {
                    // Handle other user types if necessary
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sign up prompt
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(color: Colors.white70),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to CreateAccount page when Sign up is clicked
                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (context) => CreateAccountPage()),
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xFF00F7B1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}