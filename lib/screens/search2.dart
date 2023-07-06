import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _searchUsers(String query) {
    // Clear previous search results
    setState(() {
      _searchResults.clear();
    });

    // Query Firestore collection for matching users
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: query)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          // Store matching usernames in search results
          _searchResults = snapshot.docs.map<String>((doc) => doc['username'] as String).toList();
        });
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                  hintText: 'Search for a user',
                ),
                onChanged: _searchUsers,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    onTap: () {
                      // Implement going to that users profile using Navigator.push()
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}