import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sujin/Functions/product_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class PlaceOrderScreen extends StatefulWidget {
  final String comName;
  const PlaceOrderScreen({Key? key, required this.comName}) : super(key: key);
  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<OrderItem> _orders = [];

  Future<void> generatePDF() async {
    // Create a new PDF document
    PdfDocument document = PdfDocument();

    try {
      // Add a page to the document
      PdfPage page = document.pages.add();
      // Create a PDF layout format
      PdfLayoutResult? result = PdfTextElement(
        text:
            '${widget.comName}\nDate: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        font: PdfStandardFont(PdfFontFamily.helvetica, 20),
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 100),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
      );

      // Calculate remaining height for table
      double remainingHeight =
          page.getClientSize().height - result!.bounds.bottom;
      // Define the table
      PdfGrid grid = PdfGrid();

      grid.columns.add(count: 3);
      final PdfGridRow headerRow = grid.headers.add(1)[0];

      headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
      headerRow.style.textBrush = PdfBrushes.white;

      // Add headers to the grid
      headerRow.cells[0].value = 'Sequence number';
      headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
      headerRow.cells[1].value = 'Model Name';
      headerRow.cells[2].value = 'Quantity';
      // Add data to the table
      if (_orders.isNotEmpty) {
        for (int i = 0; i < _orders.length; i++) {
          var order = _orders[i];
          addProducts((i + 1).toString(), order.modelName,
              '${order.quantity} BOX', grid);

          saveOrderToFirebase(widget.comName, order.modelName, order.quantity);
          printOrdersFromFirebase();
        }
      } else {
        log('Orders list is empty');
      }

      // Draw the table
      result = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 10,
            page.getClientSize().width, remainingHeight - 10),
      );
      // Save the document

      final List<int> bytes = document.saveSync();
      document.dispose();
      await saveAndLaunchFile(bytes,
          '${widget.comName}_${DateFormat('yyyyMMdd').format(DateTime.now())}_order.pdf');
    } catch (e, stackTrace) {
      log('Error generating PDF: $e\n$stackTrace');
    }
  }

// Function to save order data to Firebase
  Future<void> saveOrderToFirebase(
      String companyName, String modelName, int quantity) async {
    try {
      // Create a reference to the orders collection
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      // Check if there is an existing order for today from this company
      QuerySnapshot querySnapshot = await orders
    .where('companyName', isEqualTo: companyName)
    .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
    .where('modelName', arrayContains: modelName.split(' ')) // Check if modelName is contained in the document's modelName array
    .get();
print('Model Name (Adding): $modelName');
      if (querySnapshot.docs.isNotEmpty) {
        // If an order exists, update the quantity for each model
        querySnapshot.docs.forEach((doc) {
          print('Model Name (Query): ${doc['modelName']}');
          int currentQuantity = doc['quantity'] ?? 0;
          orders.doc(doc.id).update({'quantity': currentQuantity + quantity});
        });
      } else {
        // If no order exists, create a new one
        await orders.add({
          'companyName': companyName,
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'modelName': modelName,
          'quantity': quantity
        });
      }
    } catch (e) {
      log('Error saving order to Firebase: $e');
    }
  }

  Future<void> printOrdersFromFirebase() async {
  try {
    // Reference to the orders collection
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    // Get all documents from the collection
    QuerySnapshot querySnapshot = await orders.get();

    // Print each document's data
    querySnapshot.docs.forEach((doc) {
      if(doc['companyName']=='VH'){
        print('Document ID: ${doc.id}');
      print('Company Name: ${doc['companyName']}');
      print('Date: ${doc['date']}');
      print('Model Name: ${doc['modelName']}'); 
      print('Quantity: ${doc['quantity']}');
      print('----------------------------------');
      }
    });
  } catch (e) {
    print('Error fetching data from Firebase: $e');
  }
}

  void addProducts(String i, String modelName, String quantity, PdfGrid grid) {
    try {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = i;
      row.cells[1].value = modelName;
      row.cells[2].value = quantity;
    } catch (e) {
      log('Error adding products to PDF: $e');
    }
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    log(path!);
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.comName}  Place Order'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/Sujin.png', // Replace with your logo image path
                        width: MediaQuery.of(context).size.width *
                            0.5, // Adjust width as needed
                        height: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.white
                            .withOpacity(0.3), // Adjust height as needed
                        fit: BoxFit.contain,
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 400, // Set maximum width for content
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return ProductData.suggestions
                                      .where((String option) {
                                    return option.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase(),
                                        );
                                  });
                                },
                                onSelected: (String selection) {
                                  _modelNameController.text = selection;
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onFieldSubmitted: (_) => onFieldSubmitted(),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Model Name',
                                      prefixIcon: Icon(Icons.article,
                                          color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: TextFormField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Quantity (in box)',
                                  prefixIcon:
                                      Icon(Icons.category, color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 20),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Add functionality to process the order here
                                String modelName = _modelNameController.text;
                                String quantityText = _quantityController.text;

                                int quantity = int.tryParse(quantityText) ?? 0;
                                print('Model Name: $modelName');
                                print('Quantity: $quantity');

                                // Check if the model is already present in orders
                                bool modelExists = false;
                                for (var order in _orders) {
                                  if (order.modelName == modelName) {
                                    // Model already exists, update the quantity
                                    order.quantity += quantity;
                                    modelExists = true;
                                    break;
                                  }
                                }

                                // If the model is not present, add it to the orders
                                setState(() {
                                  if (!modelExists) {
                                    _orders.add(OrderItem(
                                      modelName: modelName,
                                      quantity: quantity,
                                    ));
                                  } else {
                                    // Update the quantity or remove the entry if the latest quantity is 0 or negative
                                    if (quantity <= 0) {
                                      _orders.removeWhere((order) =>
                                          order.modelName == modelName);
                                    } else {
                                      // Update the quantity
                                      _orders
                                          .firstWhere((order) =>
                                              order.modelName == modelName)
                                          .quantity = quantity;
                                    }
                                  }
                                  _orders;
                                });
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Theme.of(context).primaryColor;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide.none,
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 16),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Orders',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 200,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Model Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Quantity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _orders.length,
                                      itemBuilder: (context, index) {
                                        return OrderTile(
                                          order: _orders[index],
                                          index: index,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                log('by');
                                generatePDF();
                              },
                              child: Text(
                                'Generate',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Theme.of(context).primaryColor;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide.none,
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical: 16),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderItem order;
  final int index;

  const OrderTile({required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        color: index % 2 == 0 ? Colors.blueGrey[50] : Colors.white,
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${order.modelName}',
            style: TextStyle(color: Colors.black),
          ),
          // SizedBox(height: 5),
          Text(
            '${order.quantity}',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final String modelName;
  int quantity;

  OrderItem({required this.modelName, required this.quantity});
}
