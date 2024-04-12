import 'package:cloud_firestore/cloud_firestore.dart';

// Function to retrieve and print data from Firebase
Future<void> printOrdersFromFirebase() async {
  try {
    // Reference to the orders collection
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    // Get all documents from the collection
    QuerySnapshot querySnapshot = await orders.get();

    // Print each document's data
    querySnapshot.docs.forEach((doc) {
      print('Document ID: ${doc.id}');
      print('Company Name: ${doc['companyName']}');
      print('Date: ${doc['date']}');
      print('Model Name: ${doc['modelName']}');
      print('Quantity: ${doc['quantity']}');
      print('----------------------------------');
    });
  } catch (e) {
    print('Error fetching data from Firebase: $e');
  }
}
