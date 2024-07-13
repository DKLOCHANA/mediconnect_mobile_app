import 'package:flutter/material.dart';
import 'package:mediconnect/Pages/navbarpatient_page.dart';
import 'package:mediconnect/Pages/stroeregister_page.dart';

class AccountSelectionPage extends StatefulWidget {
  @override
  _AccountSelectionPageState createState() => _AccountSelectionPageState();
}

class _AccountSelectionPageState extends State<AccountSelectionPage> {
  String selectedAccount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the type of account you want to create and enjoy a seamless experience',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            buildAccountOption(
              context,
              'Customer',
              'As a customer, you can get your laundry done and delivered to you. You will be provided with a convenient way to book laundry sessions with our approved list of vendors. This process will be fast and seamless for you.',
              Icons.person,
              'customer',
            ),
            SizedBox(height: 10),
            buildAccountOption(
              context,
              'Vendor',
              'You operate a laundry service and wish to scale your business to more customers, this is the account for you. Receive bookings, handle and deliver laundry services to customers, receive payments all on the platform.',
              Icons.store,
              'vendor',
            ),
            SizedBox(height: 20),
            if (selectedAccount != null)
              Text(
                'You selected the $selectedAccount account',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: selectedAccount != ''
                    ? () {
                        if (selectedAccount == 'customer') {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => navbarpatient()));
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StoreRegistrationForm()));
                        }
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: selectedAccount != '' ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccountOption(BuildContext context, String title,
      String description, IconData icon, String accountType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccount = accountType;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedAccount == accountType ? Colors.blue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 40,
                color:
                    selectedAccount == accountType ? Colors.blue : Colors.grey),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
