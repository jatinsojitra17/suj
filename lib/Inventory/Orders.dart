import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedCompany = '';
  DateTime selectedDate = DateTime.now();
  List<String> companyNames = [];
  late String selcompany;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCompanyNames();
selcompany = companyNames[0];
  }


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
            children: [
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

              DropdownButton(
                isExpanded: true,
                value: selcompany,
                // value: selectedCompany.isNotEmpty ? selectedCompany : companyNames[0],
                // value: selectedCompany.isNotEmpty
                // ? selectedCompany
                // : companyNames.isNotEmpty
                //     ? companyNames[0]
                //     : null,

                onChanged: (newValue) {
                  setState(() {
                    selectedCompany = newValue!;
                  });
                },
                items: companyNames
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                // items:
                //     companyNames.map<DropdownMenuItem<String>>((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),
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
