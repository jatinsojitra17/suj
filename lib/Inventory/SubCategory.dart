import 'package:flutter/material.dart';
import 'package:sujin/Inventory/ProductSizesPage.dart';
import 'package:sujin/Functions/product_data.dart';

class SubCategoryScreen extends StatelessWidget {
  final String mainCategory;
  final String sourcePage;

  const SubCategoryScreen({
    Key? key,
    required this.mainCategory,
    required this.sourcePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pageTitle = sourcePage;
    List<String> subCategories = getSubCategories(mainCategory, sourcePage);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$pageTitle - $mainCategory',
          style:
              TextStyle(color: Color(0xFF37BB9B), fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Color(0xFF37BB9B)),
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
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(
                      MediaQuery.of(context).size.width),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  String subCategory = subCategories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductSizesPage(
                            productName: subCategory,
                            mainCategory: mainCategory,
                          ),
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
                                  mainCategory == "Baby Latch"
                                      ? 'assets/Items/Baby Latch.png'
                                      : 'assets/$mainCategory/$subCategory.png',
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
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              color: Colors.white,
                              child: Center(
                                child: Text(
                                  subCategory,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSubCategories(String mainCategory, String sourcePage) {
    switch (sourcePage) {
      case 'Ready Products':
      case 'Raw Material':
        // Return all subcategories for Ready Products and Raw Material
        return _getAllSubCategories(mainCategory);
      case 'Fit Products':
        // Return only the subcategories that need fitting for Fit Products
        return _getFitSubCategories(mainCategory);
      default:
        return [];
    }
  }

  List<String> _getAllSubCategories(String mainCategory) {
    switch (mainCategory) {
      case 'Cabinet Handles':
        return ProductData.cabinetHandles.toList();

      case 'Conceal':
        return ProductData.conceal.toList();

      case 'Profile':
        return ProductData.profiles.toList();

      case 'Kadi':
        return ProductData.kadi.toList();

      case 'Knobs':
        return ProductData.knobs.toList();

      case 'Glass Doors':
        return ProductData.glass_doors.toList();

      case 'Tower Bolt':
        return ProductData.tower_bolt.toList();

      case 'Baby Latch':
        return ProductData.baby_latch.toList();

      default:
        return [];
    }
  }

  List<String> _getFitSubCategories(String mainCategory) {
    // Implement logic to return subcategories that need fitting
    List<String> FitProducts = [];
    switch (mainCategory) {
      case 'Cabinet Handles':
        FitProducts = ['SI 008', 'SI 063', 'SI 069', 'SI 204'];
        return FitProducts.toList();

      case 'Conceal':
        return ['C-1', 'C-2', 'C-3', 'C-6'];

      case 'Glass Doors':
        return [
          'SGH 1001',
          'SGH 1002',
          'SGH 1003',
          'SGH 1004',
          'SGH 1011',
          'SGH 1012',
          'SGH 1017',
          'SGH 1018',
          'SGH 1019',
        ];
      
      case 'Kadi':
        return ProductData.kadi.toList();

      case 'Knobs':
        return ['Knob-10', 'Knob-11', 'Knob-12'];

      case 'Tower Bolt':
        return ProductData.tower_bolt.toList();

      case 'Baby Latch':
        return ProductData.baby_latch.toList();

      default:
        return [];
    }
  }

  int _calculateCrossAxisCount(double maxWidth) {
    // Calculate the number of cards per row based on the available width
    int crossAxisCount = maxWidth > 600 ? maxWidth ~/ 200 : maxWidth ~/ 150;
    // Adjust the card width (200) and the breakpoint (600) as needed
    return crossAxisCount;
  }
}
