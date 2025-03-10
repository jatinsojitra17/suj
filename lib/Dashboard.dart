// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sujin/Inventory/FitProductsScreen.dart';
// import 'package:sujin/Inventory/Orders.dart';
// import 'package:sujin/Inventory/RawMaterialScreen.dart';
// import 'package:sujin/Inventory/ReadyProductsScreen.dart';
// import 'package:sujin/Login/LoginPage.dart';
// import 'package:sujin/custom_bottom_navigation_bar.dart'; // Import the custom bottom navigation bar

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);

//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   int _selectedIndex = 0;
//   static List<Widget> _widgetOptions = <Widget>[
//     ReadyProductsScreen(),
//     FitProductsScreen(),
//     RawMaterialScreen(),
//     OrdersPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _logout() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
//           content: Text(
//             "Are you sure you want to logout?",
//             style: TextStyle(fontSize: 16),
//           ),
//           actionsPadding: EdgeInsets.symmetric(horizontal: 20),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text(
//                 "No",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Perform logout action here
//                 // For example, you can navigate to the login screen

//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.clear(); // Clear all data in shared preferences
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );

//                 // Perform logout action here, such as navigating to the login screen
//               },
//               child: Text(
//                 "Yes",
//                 style: TextStyle(color: Colors.green),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           elevation: 5,
//           backgroundColor: Colors.white,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60.0), // Adjust the height as needed
//         child: AppBar(
//           title: SizedBox(
//             height: 70, // Adjust the height as needed
//             child: Image.asset(
//               'assets/SujinAppBar.png', // Replace 'assets/logo.png' with the path to your logo image
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: _logout,
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: CustomBottomNavigationBar(
//           // Replace the BottomNavigationBar with CustomBottomNavigationBar
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sujin/Inventory/FitProductsScreen.dart';
import 'package:sujin/Inventory/Orders.dart';
import 'package:sujin/Inventory/RawMaterialScreen.dart';
import 'package:sujin/Inventory/ReadyProductsScreen.dart';
import 'package:sujin/Login/LoginPage.dart';
import 'package:sujin/custom_bottom_navigation_bar.dart'; // Import the custom bottom navigation bar

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ReadyProductsScreen(),
    FitProductsScreen(),
    RawMaterialScreen(),
    OrdersPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
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
    final isMobile = MediaQuery.of(context).size.width < 600; // Check if the screen width is less than 600 pixels (indicating a mobile device)

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Adjust the height as needed
        child: AppBar(
          title: SizedBox(
            height: 70, // Adjust the height as needed
            child: Image.asset(
              'assets/SujinAppBar.png', // Replace 'assets/logo.png' with the path to your logo image
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: isMobile ? null : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      drawer: isMobile ? Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: SizedBox(
                height: 70,
                child: Image.asset('assets/SujinAppBar.png'),
              ),
            ),
            ListTile(
              title: Text('Ready Products',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF37BB9B))),
              leading: Icon(Icons.inventory,color: Color(0xFF37BB9B)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Fit Products', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF37BB9B))),
              leading: Icon(Icons.build,color: Color(0xFF37BB9B)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Raw Material',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF37BB9B))),
              leading: Icon(Icons.colorize,color: Color(0xFF37BB9B)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Orders',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF37BB9B))),
              leading: Icon(Icons.new_releases_rounded,color: Color(0xFF37BB9B)),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ) : null,
    );
  }
}
