// import 'package:flutter/material.dart';
// import 'package:mis_lab2/services/api_services.dart';
// import '../models/joke.dart';
//
// class JokesScreen extends StatefulWidget {
//   final String type;
//   final List<Map<String, String>> favoriteJokes;
//   final Function(List<Map<String, String>>) updateFavorites;
//
//   JokesScreen({required this.type, required this.favoriteJokes, required this.updateFavorites});
//
//   @override
//   _JokesScreenState createState() => _JokesScreenState();
// }
//
// class _JokesScreenState extends State<JokesScreen> {
//   late Future<List<Joke>> jokes;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchJokes();
//   }
//
//   void fetchJokes() {
//     jokes = ApiService.fetchJokesByType(widget.type);
//   }
//
//
//   bool isFavorite(Joke joke) {
//     return widget.favoriteJokes.any((favJoke) => favJoke['setup'] == joke.setup && favJoke['punchline'] == joke.punchline);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.type} Jokes"),
//         backgroundColor: Colors.purple,
//       ),
//       backgroundColor: Colors.purple[50],
//       body: FutureBuilder<List<Joke>>(
//         future: jokes,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No jokes found."));
//           } else {
//             final jokeList = snapshot.data!;
//             return ListView.builder(
//               itemCount: jokeList.length,
//               itemBuilder: (context, index) {
//                 final joke = jokeList[index];
//                 bool isFav = isFavorite(joke);
//
//                 return Card(
//                   color: Colors.purple[100],
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       joke.setup,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.purple[800],
//                       ),
//                     ),
//                     subtitle: Text(
//                       joke.punchline,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.purple[700],
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(
//                         isFav ? Icons.favorite : Icons.favorite_border,
//                         color: isFav ? Colors.red : Colors.purple,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (isFav) {
//                             widget.favoriteJokes.removeWhere((favJoke) => favJoke['setup'] == joke.setup && favJoke['punchline'] == joke.punchline);
//                           } else {
//                             widget.favoriteJokes.add({
//                               'setup': joke.setup,
//                               'punchline': joke.punchline,
//                             });
//                           }
//                         });
//
//                         widget.updateFavorites(widget.favoriteJokes);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mis_lab2/services/api_services.dart';
import '../models/joke.dart';

class JokesScreen extends StatefulWidget {
  final String type;
  final List<Map<String, String>> favoriteJokes;
  final Function(List<Map<String, String>>) updateFavorites;

  JokesScreen({required this.type, required this.favoriteJokes, required this.updateFavorites});

  @override
  _JokesScreenState createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  late Future<List<Joke>> jokes;

  @override
  void initState() {
    super.initState();
    fetchJokes();
  }

  void fetchJokes() {
    jokes = ApiService.fetchJokesByType(widget.type);
  }

  // Check if the joke is in the favorites list
  bool isFavorite(Joke joke) {
    return widget.favoriteJokes.any((favJoke) =>
    favJoke['setup'] == joke.setup && favJoke['punchline'] == joke.punchline);
  }

  // Toggle favorite status
  void toggleFavorite(Joke joke) {
    setState(() {
      if (isFavorite(joke)) {
        // Remove from favorites
        widget.favoriteJokes.removeWhere((favJoke) =>
        favJoke['setup'] == joke.setup && favJoke['punchline'] == joke.punchline);
      } else {
        // Add to favorites
        widget.favoriteJokes.add({'setup': joke.setup, 'punchline': joke.punchline});
      }
    });
    widget.updateFavorites(widget.favoriteJokes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type} Jokes"),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.purple[50],
      body: FutureBuilder<List<Joke>>(
        future: jokes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No jokes found."));
          } else {
            final jokeList = snapshot.data!;

            return ListView.builder(
              itemCount: jokeList.length,
              itemBuilder: (context, index) {
                final joke = jokeList[index];
                bool isFav = isFavorite(joke);

                return Card(
                  color: Colors.purple[100],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      joke.setup,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    subtitle: Text(
                      joke.punchline,
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.purple[700],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.purple,
                      ),
                      onPressed: () => toggleFavorite(joke), // Toggle favorite
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
