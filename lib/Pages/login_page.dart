import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/Pages/forgot_PW_page.dart';
import 'package:mediconnect/Pages/register_page.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback showRegisterPage;

  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => __LoginPagState();
}

class __LoginPagState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false; // Add this line

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon(Icons.login, size: 100),
                  Image.asset(
                    'assets/medi_connect.png',
                    width: 150,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Hello Again!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome back ',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email';
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
                      obscureText:
                          !_passwordVisible, // Use _passwordVisible here
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPasswordPage();
                            }));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    // child: ElevatedButton(

                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       signIn();
                    //     }
                    //   },
                    //   child: Text("Sign in", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    // ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        )),
                        child: Text(' Register Now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
