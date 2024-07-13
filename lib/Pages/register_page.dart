import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/Pages/login_page.dart';
import 'package:mediconnect/Pages/selection_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey for form validation

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        addUserDetails(
          userCredential.user!,
          _usernameController.text.trim(),
          _emailController.text.trim(),
        ).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AccountSelectionPage(),
                )));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> addUserDetails(User user, String username, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': email,
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Add form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.android, size: 80),
                  Image.asset(
                    'assets/medi_connect.png',
                    width: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hello There!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  Text(
                    'Welcome to Mediconnect ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _confirmpasswordController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(_confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        )),
                        child: Text(
                          ' Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
