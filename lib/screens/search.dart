import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noot_app/screens/home_page.dart';
import 'package:noot_app/models/user.dart';
import 'package:noot_app/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef.where("username", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  String searchQuery = "";


  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.grey[200],
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search for a user...",
          filled: true,
          prefixIcon: const Icon(
            Icons.account_box,
            size: 28,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearSearch(),
          ),
        ),
        onChanged: (val){
          setState(() {
            searchQuery = val;
          });
        },
      ),
    );
  }

  Container buildNoContent() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset('assets/images/search.svg', height: 60),
            const Text("Find Users",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 60,
                ),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        List<Text> searchResults = [];

        if(snapshot.hasData) {
          snapshot.data!.docs.forEach((document) {
            UserModel users = UserModel.fromDocument(document);
            UserResult userResult  = UserResult();
            searchResults.add(Text(userResult.toString()));
          });
        }
        return ListView(
          children:
            searchResults,
        );
      },
    );
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Text("User Result");
  }
}