import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediconnect/Pages/navbar_page.dart';

class StoreRegistrationForm extends StatefulWidget {
  @override
  _StoreRegistrationFormState createState() => _StoreRegistrationFormState();
}

class _StoreRegistrationFormState extends State<StoreRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeContactNoController =
      TextEditingController();
  final TextEditingController _storeRegistrationNoController =
      TextEditingController();
  final TextEditingController _storeStreetController = TextEditingController();
  final TextEditingController _storeCityController = TextEditingController();
  final TextEditingController _storeDistrictController =
      TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextField(
                  controller: _storeNameController,
                  labelText: 'Store Name',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the store name'
                      : null,
                ),
                _buildTextField(
                  controller: _storeContactNoController,
                  labelText: 'Store Contact No',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the store contact number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _storeRegistrationNoController,
                  labelText: 'Store Registration No',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the store registration number'
                      : null,
                ),
                _buildTextField(
                  controller: _storeStreetController,
                  labelText: 'Store Street',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the store street'
                      : null,
                ),
                _buildTextField(
                  controller: _storeCityController,
                  labelText: 'Store City',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the store city'
                      : null,
                ),
                _buildTextField(
                  controller: _storeDistrictController,
                  labelText: 'Store District',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the store district'
                      : null,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _onRegisterButtonPressed,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Register",
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }

  void _onRegisterButtonPressed() {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState!.validate()) {
      _registerStore();
    }
  }

  void _registerStore() {
    String storeName = _storeNameController.text;
    String storeContactNo = _storeContactNoController.text;
    String storeRegistrationNo = _storeRegistrationNoController.text;
    String storeStreet = _storeStreetController.text;
    String storeCity = _storeCityController.text;
    String storeDistrict = _storeDistrictController.text;

    CollectionReference storesCollection =
        FirebaseFirestore.instance.collection('stores');
    storesCollection.add({
      'userEmail': currentUser.email,
      'storeName': storeName,
      'storeContactNo': storeContactNo,
      'storeRegistrationNo': storeRegistrationNo,
      'storeStreet': storeStreet,
      'storeCity': storeCity,
      'storeDistrict': storeDistrict,
    }).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Navbar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Store registered successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    });

    _clearFormFields();
  }

  void _clearFormFields() {
    _storeNameController.clear();
    _storeContactNoController.clear();
    _storeRegistrationNoController.clear();
    _storeStreetController.clear();
    _storeCityController.clear();
    _storeDistrictController.clear();

    setState(() {
      _submitted = false;
    });
  }
}
