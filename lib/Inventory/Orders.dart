import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF37BB9B),
              Color(0xFF71D9E2), // Lighter shade of the brand color
            ],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/Sujin.png', // Replace with your logo image path
                  width: MediaQuery.of(context).size.width *
                      0.5, // Adjust width as needed
                  height: MediaQuery.of(context).size.width * 0.5,
                  color:
                      Colors.white.withOpacity(0.3), // Adjust height as needed
                  fit: BoxFit.contain,
                ),
              ),
              OrdersList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Process data to merge orders based on company name and date
        Map<String, Map<String, List<DocumentSnapshot>>> mergedOrders = {};
        snapshot.data!.docs.forEach((doc) {
          String companyName = doc['companyName'];
          String date = doc['date'];
          if (!mergedOrders.containsKey(companyName)) {
            mergedOrders[companyName] = {};
          }
          if (!mergedOrders[companyName]!.containsKey(date)) {
            mergedOrders[companyName]![date] = [];
          }
          mergedOrders[companyName]![date]!.add(doc);
        });

        return ListView.builder(
          itemCount: mergedOrders.length,
          itemBuilder: (context, index) {
            String companyName = mergedOrders.keys.elementAt(index);
            return ExpansionTile(
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.3), // Adjust color as needed
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Company Name: $companyName',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              children: mergedOrders[companyName]!.entries.map((entry) {
                String date = entry.key;
                List<DocumentSnapshot> orders = entry.value;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Date: $date'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: orders.map((order) {
                          return Text(
                            'Model Name: ${order['modelName']}, Quantity: ${order['quantity']} Boxes',
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
