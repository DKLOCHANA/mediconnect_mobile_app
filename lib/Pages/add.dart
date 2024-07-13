import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final _productNameController = TextEditingController();
  final _drugDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool _showValidationMessages = false;
  final _uuid = Uuid();

  Future<String?> _getStoreName() async {
    try {
      final storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('userEmail', isEqualTo: currentUser.email)
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        return storeSnapshot.docs.first.data()['storeName'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting store name: $e');
      return null;
    }
  }

  void _addProduct(BuildContext context) async {
    setState(() {
      _showValidationMessages = true;
    });

    if (_formKey.currentState!.validate()) {
      final storeName = await _getStoreName();

      if (storeName != null) {
        final uniqueId = _uuid.v4(); // Generate a unique ID
        CollectionReference collref =
            FirebaseFirestore.instance.collection('drugs');
        collref.doc(uniqueId).set({
          'id': uniqueId,
          'name': _productNameController.text,
          'description': _drugDescriptionController.text,
          'price': _priceController.text,
          'quantity': _quantityController.text,
          'userEmail': currentUser.email.toString(),
          'storeName': storeName
        });

        // Clear text fields
        _productNameController.clear();
        _drugDescriptionController.clear();
        _priceController.clear();
        _quantityController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
          ),
        );

        setState(() {
          _showValidationMessages = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Store name not found'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _showValidationMessages
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                const SizedBox(height: 20),

                // Product Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _productNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Product Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Drug Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        height:
                            150, // Adjust this value as needed for a 50% increase in height
                        child: TextFormField(
                          controller: _drugDescriptionController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Drug Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the drug description';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Price and Quantity in one row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Price',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the price';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Quantity',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () => _addProduct(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Add Product",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
