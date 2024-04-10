import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sujin/Login/LoginPage.dart';
import 'package:sujin/Merchant/BrochurePage.dart';
import 'package:sujin/Merchant/PlaceOrderScreen.dart';

class MerchantPage extends StatefulWidget {
  final String companymail;
  const MerchantPage({Key? key, required this.companymail}) : super(key: key);

  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  late Future<String> _abbreviationFuture;

  @override
  void initState() {
    super.initState();
    _abbreviationFuture = _fetchCompanyName();
  }

  Future<String> _fetchCompanyName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(widget.companymail)
          .get();

      String companyName = userDoc.get('company name');
      return _getAbbreviation(companyName);
    } catch (e) {
      print('Error fetching company name: $e');
      return ''; // Return empty string or any default value
    }
  }

  String _getAbbreviation(String companyName) {
    List<String> words = companyName.split(' ');
    List<String> initials = words.map((word) => word[0]).toList();
    return initials.join('');
  }

  late String comName;

  void _logout() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all data in shared preferences
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF37BB9B),
        title: FutureBuilder<String>(
          future: _abbreviationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...', style: TextStyle(color: Colors.white));
            } else {
              comName = snapshot.data ?? '';
              return Text(snapshot.data ?? '',
                  style: TextStyle(color: Colors.white));
            }
          },
        ),
        actions: [IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF37BB9B),
              Color(0xFF71D9E2),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/Sujin.png', // Replace with your logo image path
                width: MediaQuery.of(context).size.width *
                    0.5, // Adjust width as needed
                height: MediaQuery.of(context).size.width * 0.5,
                color: Colors.white, // Adjust height as needed
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaceOrderScreen(
                                  comName: comName,
                                )),
                      );
                    },
                    child: Text('Place Order'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).primaryColor;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.3),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BrochurePage()),
                      );
                    },
                    child: Text('Access Brochure'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Theme.of(context).primaryColor;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide.none,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      ),
                      elevation: MaterialStateProperty.all<double>(5),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.black.withOpacity(0.3),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
