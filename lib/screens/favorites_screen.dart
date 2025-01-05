import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteJokes;

  FavoritesScreen({required this.favoriteJokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Jokes"),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[50],
      body: favoriteJokes.isEmpty
          ? Center(
        child: Text(
          "No favorite jokes yet!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = favoriteJokes[index];
          return Card(
            color: Colors.purple[100],
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(joke["setup"]!),
              subtitle: Text(joke["punchline"]!),
            ),
          );
        },
      ),
    );
  }
}
