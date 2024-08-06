import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;
  Future<QuerySnapshot>? searchResultsFuture;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void handleSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        isSearch = true;
        searchResultsFuture = FirebaseFirestore.instance
            .collection('user')
            .where('username', isGreaterThanOrEqualTo: query)
            .get();
      });
    } else {
      setState(() {
        isSearch = false;
        searchResultsFuture = null;
      });
    }
  }

  Widget buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var userDoc = snapshot.data!.docs[index];
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(uid: snapshot.data!.docs[index]['uid']),
              )),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userDoc['photoUrl']),
                ),
                title: Text(userDoc['username']),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Search for User'),
            onFieldSubmitted: handleSearch,
          ),
        ),
        body: isSearch
            ? buildSearchResults()
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("posts").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var postDoc = snapshot.data!.docs[index];
                      return Image.network(
                        postDoc['postUrl'],
                        fit: BoxFit.cover,
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1,
                      (index % 7 == 0) ? 2 : 1,
                    ),
                  );
                },
              ));
  }
}
