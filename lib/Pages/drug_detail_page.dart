import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediconnect/widgets/itemdashboard.dart';

class DrugDetailPage extends StatelessWidget {
  final DocumentSnapshot drugSnapshot;

  DrugDetailPage({required this.drugSnapshot});

  Future<DocumentSnapshot?> _getStoreDetails(String storeName) async {
    try {
      final storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('storeName', isEqualTo: storeName)
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        return storeSnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting store details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          drugSnapshot['name'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _getStoreDetails(drugSnapshot['storeName']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Store details not found'));
          } else {
            var storeData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Drug Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  itemProfile2('Name', drugSnapshot['name'],
                      Icons.medical_services_outlined),
                  SizedBox(height: 8),
                  itemProfile2('Description', drugSnapshot['description'],
                      Icons.description_outlined),
                  SizedBox(height: 8),
                  itemProfile2('Price', 'Rs.${drugSnapshot['price']}.00/=',
                      Icons.attach_money_outlined),
                  SizedBox(height: 24),
                  Text('Store Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  itemProfile2(
                      'Name', storeData['storeName'], Icons.store_outlined),
                  SizedBox(height: 8),
                  itemProfile2('Contact', storeData['storeContactNo'],
                      Icons.phone_outlined),
                  SizedBox(height: 8),
                  itemProfile3(
                      'Address',
                      storeData['storeStreet'],
                      storeData['storeCity'],
                      storeData['storeDistrict'],
                      Icons.location_on_outlined),
                  SizedBox(height: 8),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
