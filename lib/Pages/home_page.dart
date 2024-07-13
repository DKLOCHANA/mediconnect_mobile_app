import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'drug_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = 'Islandwide'; // Default location

  @override
  void initState() {
    getClientStream();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text.isEmpty) {
      showResults = List.from(_allResults); // Show all drugs
    } else {
      for (var drugSnapshot in _allResults) {
        var name = drugSnapshot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(drugSnapshot);
        }
      }
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('drugs')
        .orderBy('name')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 5,
        title: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.white,
                  controller: _searchController,
                ),
              ),
              SizedBox(width: 10),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: _selectedLocation,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue!;
                          // Implement location-based filtering if needed
                        });
                      },
                      items: <String>[
                        'Islandwide',
                        'Kegalle',
                        'Kandy',
                        'Colombo'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _resultList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: EdgeInsets.all(9),
                child: ListTile(
                  title: Text('Name: ' + _resultList[index]['name']),
                  subtitle: Text('Store: ' + _resultList[index]['storeName']),
                  trailing:
                      Text('Price: Rs. ' + _resultList[index]['price'] + '.00'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrugDetailPage(
                          drugSnapshot: _resultList[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
