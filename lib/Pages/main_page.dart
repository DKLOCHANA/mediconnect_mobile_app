import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:mediconnect/Auth/auth_page.dart';
import 'package:mediconnect/Pages/login_page.dart';
//import 'package:mediconnect/Pages/home_page.dart';
import 'package:mediconnect/Pages/navbar_page.dart';
import 'package:mediconnect/Pages/navbarpatient_page.dart';
//import 'package:mediconnect/Pages/login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // User is authenticated
          User? user = snapshot.data;
          String? email = user?.email;
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('stores')
                .where('userEmail', isEqualTo: email)
                .get(),
            builder: (context, querySnapshot) {
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (querySnapshot.hasError) {
                return Center(child: Text("Error: ${querySnapshot.error}"));
              }
              if (querySnapshot.hasData &&
                  querySnapshot.data!.docs.isNotEmpty) {
                // Email found in stores collection
                return Navbar();
              } else {
                // Email not found in stores collection
                return navbarpatient();
              }
            },
          );
        } else {
          return LoginPage();
        }
      },
    ));
  }
}
