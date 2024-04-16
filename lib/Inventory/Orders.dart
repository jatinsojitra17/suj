import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}


class _OrdersPageState extends State<OrdersPage> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompanyNames();
  }

  String selectedCompany = '';
  DateTime selectedDate = DateTime.now();
  List<String> companyNames = [];

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

  Future<List<String>> _getCompanyNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    
    querySnapshot.docs.forEach((doc) {
      String companyName = doc['company name'];
      print('Company Name: $companyName');
      if (!companyNames.contains(companyName)) {
        companyNames.add(companyName);
      }
    });
    log('${companyNames}');
    return companyNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            <Widget>[
              FutureBuilder<List<String>>(
                future: _getCompanyNames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return 
                    // DropdownButton<String>(
                    //   value: selectedCompany,
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       selectedCompany = newValue!;
                    //     });
                    //   },
                    //   items: snapshot.data!
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // );

                    DropdownButton<String>(
  value: selectedCompany,
  onChanged: (String? newValue) {
    setState(() {
      selectedCompany = newValue!;
    });
  },
  items: companyNames.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
);

                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showDatePicker(context),
                child: Text('Select Date'),
              ),
              SizedBox(height: 20),
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
                    print(
                        'Model Name: ${doc['modelName']}, Quantity: ${doc['quantity']}');
                  });
                },
                child: Text('Show Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
