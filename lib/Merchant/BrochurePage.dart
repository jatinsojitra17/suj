import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class BrochurePage extends StatefulWidget {
  const BrochurePage({super.key});

  @override
  State<BrochurePage> createState() => _BrochurePageState();
}

class _BrochurePageState extends State<BrochurePage> {
  late PdfControllerPinch pdfControllerPinch;
  int totalPageCount = 0, currentPage = 1;

  @override
  void initState() {
    super.initState();
    pdfControllerPinch = PdfControllerPinch(
        document:
            PdfDocument.openAsset('assets/pdfs/SUJIN2022Brochure.pdf'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Brochure',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF37BB9B), // Use your app's primary color
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Pages : $totalPageCount"),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      pdfControllerPinch.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text("Page : $currentPage / $totalPageCount"),
                  IconButton(
                    onPressed: () {
                      pdfControllerPinch.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: _pdfView()),
      ],
    );
  }

  Widget _pdfView() {
    return PdfViewPinch(
      scrollDirection: Axis.vertical,
      controller: pdfControllerPinch,
      onDocumentLoaded: (doc) {
        setState(() {
          totalPageCount = doc.pagesCount;
        });
      },
      onPageChanged: (page) {
        setState(() {
          currentPage = page;
        });
      },
    );
  }
}
