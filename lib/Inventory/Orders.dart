import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedCompany = '';
  DateTime selectedDate = DateTime.now();

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedCompany,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCompany = newValue!;
                });
              },
              items: <String>['Company A', 'Company B', 'Company C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () => _showDatePicker(context),
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Query orders based on selectedCompany and selectedDate
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .where('companyName', isEqualTo: selectedCompany)
                    .where('date', isEqualTo: selectedDate)
                    .get();

                // Display orders
                querySnapshot.docs.forEach((doc) {
                  print('Model Name: ${doc['modelName']}, Quantity: ${doc['quantity']}');
                });
              },
              child: Text('Show Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
