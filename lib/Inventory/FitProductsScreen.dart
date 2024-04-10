import 'package:flutter/material.dart';
import 'package:sujin/Inventory/SubCategory.dart';

class FitProductsScreen extends StatefulWidget {
  @override
  _FitProductsScreenState createState() => _FitProductsScreenState();
}

class _FitProductsScreenState extends State<FitProductsScreen> {
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
              Color(0xFF71D9E2),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/Sujin.png', // Replace with your logo image path
                width: MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
        height: MediaQuery.of(context).size.width * 0.5,
                color: Colors.white, // Adjust height as needed
                fit: BoxFit.contain,
              ),
            ),
LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              int crossAxisCount = maxWidth > 600 ? 4 : 2;
          
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                padding: EdgeInsets.all(10.0),
                children: [
                  ProductCard(
                      name: 'Cabinet Handles',
                      imagePath: 'assets/Items/Cabinet Handles.png'),
                  ProductCard(name: 'Conceal', imagePath: 'assets/Items/Conceal.png'),
                  ProductCard(name: 'Kadi', imagePath: 'assets/Items/Kadi.png'),
                  ProductCard(name: 'Knobs', imagePath: 'assets/Items/Knobs.png'),
                  ProductCard(
                      name: 'Glass Doors', imagePath: 'assets/Items/Glass Doors.png'),
                  ProductCard(name: 'Tower Bolt', imagePath: 'assets/Items/Tower Bolt.png'),
                  ProductCard(name: 'Baby Latch', imagePath: 'assets/Items/Baby Latch.png'),
                ],
              );
            },
          ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const ProductCard({Key? key, required this.name, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryScreen(mainCategory: name,sourcePage: 'Fit Products'), 
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
