import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late User currentUser;
  late CollectionReference myItems;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    myItems = FirebaseFirestore.instance.collection('drugs');
  }

  Future<void> delete(String productId) async {
    try {
      await myItems.doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted Successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Store', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: myItems
            .where('userEmail', isEqualTo: currentUser.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (streamSnapshot.hasError) {
            return Center(child: Text('Error: ${streamSnapshot.error}'));
          } else if (streamSnapshot.hasData &&
              streamSnapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final documentSnapshot = streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ListTile(
                        title: Text(
                          documentSnapshot['name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: Rs.${documentSnapshot['price']}.00/=',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Quantity: ${documentSnapshot['quantity']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Description: ${documentSnapshot['description']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => delete(documentSnapshot.id),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No items found.'));
          }
        },
      ),
    );
  }
}
