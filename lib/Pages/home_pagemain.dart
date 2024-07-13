import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/Pages/home_page.dart';

class MainHomePage extends StatelessWidget {
  Future<String> fetchUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String? email = currentUser.email;
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first['username'];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: fetchUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No username found.'));
          } else {
            String userName = snapshot.data!;
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 220,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Text(
                              'Hello $userName,',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              'Please bring prescription with you while visiting drug store.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                    ),
                                    Text('Search Your Medicine Here...'),
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Icon(Icons.search,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Card(
                              elevation: 5,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/1.png'),
                                    fit: BoxFit
                                        .cover, // Optional: to cover the entire container
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Card(
                              elevation: 5,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/2.png'),
                                    fit: BoxFit
                                        .fill, // Optional: to cover the entire container
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Center(
        child: Text('This is the search page.'),
      ),
    );
  }
}
