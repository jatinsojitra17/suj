import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sujin/Functions/custom_table.dart';
import 'package:sujin/Functions/product_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductSizesPage extends StatefulWidget {
  final String productName;
  final String mainCategory;

  const ProductSizesPage({
    Key? key,
    required this.productName,
    required this.mainCategory,
  }) : super(key: key);

  @override
  _ProductSizesPageState createState() => _ProductSizesPageState();
}

class _ProductSizesPageState extends State<ProductSizesPage> {
  late String _selectedSize;
  late String _selectedFinish;
  List<String> _availableFinishes = [];
  int availPieces = 0;
  Map<String, dynamic>? _availablePiecesData;
  TextEditingController updatePiece = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSize = '';
    _selectedFinish = '';
    // Fetch data from Firestore when the page is initialized
    _fetchAvailablePiecesData();
  }

  // Function to fetch available pieces data from Firestore
  Future<void> _fetchAvailablePiecesData() async {
    try {
      // Access Firestore collection "Products" and document with the product name
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productName)
          .get();

      // Access the "availablePieces" field from the document
      setState(() {
        _availablePiecesData = productDoc['availablePieces'];
      });
    } catch (e) {
      // Handle errors
      Fluttertoast.showToast(
        msg: 'Data Not Available',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
      );
    }
  }

  // Widget to display available pieces based on selected size and finish
  Widget _buildAvailablePieces() {
    _selectedFinish = _selectedFinish.replaceAll('/', '-');
    if (_availablePiecesData != null &&
        _selectedSize.isNotEmpty &&
        _selectedFinish.isNotEmpty) {
      int? availablePieces =
          _availablePiecesData![_selectedSize][_selectedFinish];
      if (availablePieces != null) {
        availPieces = availablePieces;
        // Update availPieces here
        return Text(
          'Available Pieces for $_selectedSize ($_selectedFinish): $availPieces',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
    // Return empty container if data is not available or selections are empty
    return Container();
  }

  // Function to update available pieces in Firestore
  void updateAvailablePieces(int newPiecesCount) {
    if (_selectedSize.isNotEmpty && _selectedFinish.isNotEmpty) {
      // Reference to the Firestore document
      var docRef = FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productName);

      // Update the available pieces for the selected size and finish
      _selectedFinish = _selectedFinish.replaceAll('/', '-');
      docRef.update({
        'availablePieces.$_selectedSize.$_selectedFinish': newPiecesCount,
      }).then((value) {
        // Success message or any other action after updating
        print('Available pieces updated successfully.');
      }).catchError((error) {
        // Error handling
        log('$error');
      });
    } else {
      // Handle case where size or finish is not selected
      print('Please select size and finish first.');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sizes = getSizes(widget.mainCategory, widget.productName);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sizes of ${widget.productName}',
          style: TextStyle(
            color: Color(0xFF37BB9B),
            fontWeight: FontWeight.bold,
          ),
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
                'assets/Sujin.png',
                width: MediaQuery.of(context).size.width *
                    0.5, // Adjust width as needed
                height: MediaQuery.of(context).size.width * 0.5,
                color: Colors.white.withOpacity(0.5),
                fit: BoxFit.contain,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sizes:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white.withOpacity(0.3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                height: 60,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: sizes.map((size) {
                                      return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            _selectedSize = size;
                                            // Reset selected finish
                                            _selectedFinish = '';
                                          });
                                          // Fetch available finishes for the selected size
                                          _availableFinishes =
                                              getFinishes(widget.productName);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _selectedSize == size
                                                ? Color(0xFF37BB9B)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                          ),
                                          child: Text(
                                            size,
                                            style: TextStyle(
                                                color: _selectedSize == size
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.5),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              if (_selectedSize.isNotEmpty) ...[
                                Text(
                                  'Finishes:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 10,
                                  children: _availableFinishes.map((finish) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedFinish = finish;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        margin: EdgeInsets.only(
                                            right: 10, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: _selectedFinish == finish
                                              ? Colors.green
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          finish,
                                          style: TextStyle(
                                            color: _selectedFinish == finish
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (_selectedFinish.isNotEmpty) ...[
                                  SizedBox(height: 20),
                                  _buildAvailablePieces(),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_selectedSize.isNotEmpty &&
                                              _selectedFinish.isNotEmpty) {
                                            int currentPieces = availPieces;
                                            int addedPieces = int.tryParse(
                                                    updatePiece.text) ??
                                                0;
                                            int newPiecesCount =
                                                currentPieces + addedPieces;

                                            updateAvailablePieces(
                                                newPiecesCount);
                                          } else {
                                            print(
                                                'Please select size and finish first.');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'ADD',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: SizedBox(
                                          width: constraints.maxWidth * 0.4,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: updatePiece,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter quantity (max 1000)',
                                              fillColor: Colors.white,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_selectedSize.isNotEmpty &&
                                              _selectedFinish.isNotEmpty) {
                                            int currentPieces = availPieces;
                                            int removedPieces = int.tryParse(
                                                    updatePiece.text) ??
                                                0;
                                            int newPiecesCount =
                                                currentPieces - removedPieces;
                                            if (newPiecesCount < 0) {
                                              newPiecesCount = 0;
                                            }
                                            updateAvailablePieces(
                                                newPiecesCount);
                                          } else {
                                            print(
                                                'Please select size and finish first.');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'REMOVE',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.amber, width: 3)),
                                        width: constraints.maxWidth * 0.45,
                                        height: constraints.maxWidth * 0.45,
                                        child: Image.asset(
                                          widget.mainCategory == "Baby Latch"
                                              ? 'assets/Items/Baby Latch.png'
                                              : 'assets/${widget.mainCategory}/${widget.productName}.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: constraints.maxWidth * 0.40,
                                        height: constraints.maxWidth * 0.45,
                                        child: CustomTable(
                                            sizes: getSizes(widget.mainCategory,
                                                widget.productName),
                                            packing:
                                                getPacking(widget.productName)),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
