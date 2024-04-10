import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<Map<String, int>> getAvailablePieces(
      String productName, String size) async {
    try {
      String path = '$productName/$size';
      log(path);
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance
          .ref()
          .child(path)
          .once() as DataSnapshot;
      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      Map<String, int> availablePieces = {};

      if (data != null) {
        data.forEach((finish, pieces) {
          availablePieces[finish.toString()] = pieces as int;
        });
      }

      return availablePieces;
    } catch (e) {
      print('Error fetching available pieces: $e');
      return {};
    }
  }

  Future<List<String>> getAvailableFinishes(
      String productName, String size) async {
    try {
      String path = '$productName/$size';
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance
          .ref()
          .child(path)
          .once() as DataSnapshot;
      Map<dynamic, dynamic>? data =
          dataSnapshot.value as Map<dynamic, dynamic>?;

      List<String> availableFinishes = [];

      if (data != null) {
        availableFinishes = data.keys.cast<String>().toList();
      }

      return availableFinishes;
    } catch (e) {
      print('Error fetching available finishes: $e');
      return [];
    }
  }

  Future<Map<String, int>> fetchAvailablePieces(
      String productName, String size) async {
    try {
      // Call the FirebaseService method to get available pieces
      Map<String, int> availablePieces =
          await FirebaseService().getAvailablePieces(productName, size);
      // You can now use the availablePieces map to access the data
      // For example, you can iterate over the map entries or access specific values
      availablePieces.forEach((finish, pieces) {
        print('Finish: $finish, Pieces: $pieces');
      });
      // Return the availablePieces map if needed
      return availablePieces;
    } catch (e) {
      // Handle any errors that might occur
      print('Error fetching available pieces: $e');
      // Return an empty map or null, depending on your error handling strategy
      return {};
    }
  }

  Future<void> addPieces(
      String productName, String size, String finish, int pieces) async {
    try {
      String path = '$productName/$size/$finish';
      await FirebaseDatabase.instance.ref().child(path).set(pieces);
    } catch (e) {
      print('Error adding pieces: $e');
    }
  }

  Future<void> removePieces(
      String productName, String size, String finish, int pieces) async {
    try {
      String path = '$productName/$size/$finish';
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance
          .ref()
          .child(path)
          .once() as DataSnapshot;
      int currentPieces = dataSnapshot.value as int? ?? 0;
      int updatedPieces = (currentPieces - pieces).clamp(0, currentPieces);
      await FirebaseDatabase.instance.ref().child(path).set(updatedPieces);
    } catch (e) {
      print('Error removing pieces: $e');
    }
  }
}
