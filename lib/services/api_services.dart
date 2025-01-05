// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/joke.dart';
//
// class ApiService {
//   static const baseUrl = "https://official-joke-api.appspot.com";
//
//   static Future<List<String>> fetchJokeTypes() async {
//     final response = await http.get(Uri.parse("$baseUrl/types"));
//     if (response.statusCode == 200) {
//       return List<String>.from(json.decode(response.body));
//     } else {
//       throw Exception("Failed to load joke types");
//     }
//   }
//
//   static Future<List<Joke>> fetchJokesByType(String type) async {
//     final response = await http.get(Uri.parse("$baseUrl/jokes/$type/ten"));
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((data) => Joke.fromJson(data))
//           .toList();
//     } else {
//       throw Exception("Failed to load jokes for type: $type");
//     }
//   }
//
//   static Future<Joke> fetchRandomJoke() async {
//     final response = await http.get(Uri.parse("$baseUrl/random_joke"));
//     if (response.statusCode == 200) {
//       return Joke.fromJson(json.decode(response.body));
//     } else {
//       throw Exception("Failed to load random joke");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joke.dart';

class ApiService {
  static const baseUrl = "https://official-joke-api.appspot.com";


  static Future<List<String>> fetchJokeTypes() async {
    final response = await http.get(Uri.parse("$baseUrl/types"));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load joke types");
    }
  }

  static Future<List<Joke>> fetchJokesByType(String type) async {
    final response = await http.get(Uri.parse("$baseUrl/jokes/$type/ten"));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Joke.fromJson(data))
          .toList();
    } else {
      throw Exception("Failed to load jokes for type: $type");
    }
  }


  static Future<Joke> fetchRandomJoke() async {
    final response = await http.get(Uri.parse("$baseUrl/random_joke"));
    if (response.statusCode == 200) {
      return Joke.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load random joke");
    }
  }


  static Future<void> saveJokesToFirestore(List<Joke> jokes) async {
    final firestore = FirebaseFirestore.instance;

    for (var joke in jokes) {
      await firestore.collection('jokes').add({
        'type': joke.type,
        'setup': joke.setup,
        'punchline': joke.punchline,
      });
    }
  }
}
