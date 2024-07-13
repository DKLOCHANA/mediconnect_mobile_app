import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/itemdashboard.dart';

class ProfileScreen extends StatefulWidget {
  final void Function()? onPressed;

  const ProfileScreen({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _storeaddresslineController = TextEditingController();
  final _storecitynameController = TextEditingController();
  final _storedistrictnameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeRegistrationNoController = TextEditingController();

  late final User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    final userData = userSnapshot.data();
    if (userData != null) {
      _nameController.text = userData['username'];
    }

    final storeSnapshot = await FirebaseFirestore.instance
        .collection('stores')
        .where('username', isEqualTo: currentUser.email)
        .get();

    if (storeSnapshot.docs.isNotEmpty) {
      final storeData = storeSnapshot.docs.first.data();
      _storeNameController.text = storeData['storeName'];
      _storeRegistrationNoController.text = storeData['storeRegistrationNo'];
      _storeaddresslineController.text = storeData['storeStreet'];
      _storecitynameController.text = storeData['storeCity'];
      _storedistrictnameController.text = storeData['storeDistrict'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    _nameController.text = userData['username'];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'User Details ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            itemProfile('User Name', _nameController,
                                Icons.person_outlined),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  color: Colors.blue,
                                  child: Text(
                                    'Sign out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("stores")
                    .where('userEmail', isEqualTo: currentUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final storeData = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;

                    _storeNameController.text = storeData['storeName'];
                    _storeRegistrationNoController.text =
                        storeData['storeRegistrationNo'];
                    _storeaddresslineController.text = storeData['storeStreet'];
                    _storecitynameController.text = storeData['storeCity'];
                    _storedistrictnameController.text =
                        storeData['storeDistrict'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Store Details ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          itemProfile4('Name', _storeNameController,
                              Icons.store_outlined),
                          const SizedBox(height: 10),
                          itemProfile4(
                              'Registration Number',
                              _storeRegistrationNoController,
                              Icons.numbers_outlined),
                          const SizedBox(height: 10),
                          itemProfile3(
                              'Address',
                              storeData['storeStreet'],
                              storeData['storeCity'],
                              storeData['storeDistrict'],
                              Icons.location_on_outlined),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const SizedBox(); // Return an empty widget when no data is available
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemProfile(
      String title, TextEditingController controller, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 122, 117, 209).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          controller.text,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Icon(iconData),
        trailing: IconButton(
          onPressed: () => editField(title),
          icon: const Icon(Icons.edit),
          color: const Color.fromARGB(255, 84, 82, 82),
        ),
        tileColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  void editField(String field) {
    TextEditingController? editingController;

    if (field == 'User Name') {
      editingController = _nameController;
      // } else if (field == 'Street') {
      //   editingController = _addresslineController;
      // } else if (field == 'City') {
      //   editingController = _citynameController;
      // } else if (field == 'District') {
      //   editingController = _districtnameController;
    }

    if (editingController != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit $field'),
            content: TextField(
              controller: editingController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  updateUserData();
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  void updateUserData() async {
    final Map<String, String> updatedData = {
      'username': _nameController.text,
      // 'addressline1': _addresslineController.text,
      // 'city': _citynameController.text,
      // 'district': _districtnameController.text,
    };

    bool updated = false;

    await Future.forEach(updatedData.entries,
        (MapEntry<String, String> entry) async {
      if (entry.value.isNotEmpty && entry.value.length > 1) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .update({entry.key.toLowerCase(): entry.value});
        updated = true;
      }
    });

    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _addresslineController.dispose();
    // _citynameController.dispose();
    // _districtnameController.dispose();
    _storeNameController.dispose();
    _storeRegistrationNoController.dispose();
    _storeaddresslineController.dispose();
    _storecitynameController.dispose();
    _storedistrictnameController.dispose();
    super.dispose();
  }
}
