// ########## OLD VERSION JUST IN CASE ###############
// import 'package:flutter/material.dart';
// import '../models/joke.dart';
// import '../services/api_services.dart';
// import 'jokes_screen.dart';
// import 'favorites_screen.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
//
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Map<String, String>> favoriteJokes = [];
//
//
//   void updateFavorites(List<Map<String, String>> updatedFavorites) {
//     setState(() {
//       favoriteJokes = updatedFavorites;
//     });
//   }
//
//   void saveJokesToFirestore(List<Joke> jokes) async {
//     try {
//       await ApiService.saveJokesToFirestore(jokes);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Jokes saved to Firestore!"),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Failed to save jokes: $e"),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Choose a type of joke"),
//         backgroundColor: Colors.purple,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.favorite),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FavoritesScreen(favoriteJokes: favoriteJokes),
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.star),
//             color: Colors.white70,
//             onPressed: () {
//               Navigator.pushNamed(context, "/random");
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.purple[50],
//       body: FutureBuilder<List<String>>(
//         future: ApiService.fetchJokeTypes(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             final types = snapshot.data!;
//             return ListView.builder(
//               itemCount: types.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   color: Colors.purple[100],
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       types[index],
//                       style: TextStyle(
//                         color: Colors.purple[800],
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onTap: () async {
//                       // Fetch jokes by type
//                       final jokes = await ApiService.fetchJokesByType(types[index]);
//                       // Save jokes to Firestore
//                       saveJokesToFirestore(jokes);
//
//                       // Navigate to the jokes screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => JokesScreen(
//                             type: types[index],
//                             favoriteJokes: favoriteJokes,
//                             updateFavorites: updateFavorites,
//                           ),
//                         ),
//                       );
//                     },
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
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/joke.dart';
import '../services/api_services.dart';
import 'jokes_screen.dart';
import 'favorites_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> favoriteJokes = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a type of joke"),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: Colors.white70,
            onPressed: () {
              Navigator.pushNamed(context, "/random");
            },
          ),
        ],
      ),
      backgroundColor: Colors.purple[50],
      body: FutureBuilder<List<String>>(
        future: ApiService.fetchJokeTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.purple[100],
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      types[index],
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {

                      final jokes = await ApiService.fetchJokesByType(types[index]);

                      saveJokesToFirestore(jokes);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JokesScreen(
                            type: types[index],
                            favoriteJokes: favoriteJokes,
                            updateFavorites: updateFavorites,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("Init state called");
  }

  void saveJokesToFirestore(List<Joke> jokes) async {
    try {
      await ApiService.saveJokesToFirestore(jokes);
      _showSnackBar("Jokes saved to Firestore!");
    } catch (e) {
      _showSnackBar("Failed to save jokes: $e");
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  void updateFavorites(List<Map<String, String>> updatedFavorites) {
    setState(() {
      favoriteJokes = updatedFavorites;
    });
  }
}


