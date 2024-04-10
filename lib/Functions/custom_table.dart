import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<String> sizes;
  final List<String> packing;

  const CustomTable({
    Key? key,
    required this.sizes,
    required this.packing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: FixedColumnWidth(50.0),
      border: TableBorder.all(color: Colors.transparent),
      children: [
    // Table header row
    TableRow(
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(10.0),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Size',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Packing',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    // Table data rows
    for (int i = 0; i < sizes.length; i++)
      TableRow(
        decoration: BoxDecoration(
          color: i % 2 == 0 ? Colors.blueGrey[50] : Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        children: [
          TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  sizes[i],
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  packing[i],
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
      ],
    );
  }}