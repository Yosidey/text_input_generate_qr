import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(home: QrHome()));



class QrHome extends StatefulWidget {
  const QrHome({Key? key}) : super(key: key);

  @override
  State<QrHome> createState() => _QrHomeState();
}

class _QrHomeState extends State<QrHome> {
  final pages = [const QrReader(), const QrGenerator()];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ejemplo")),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        selectedIndex: pageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              pageIndex == 0 ? Icons.camera_alt_rounded : Icons.camera_alt_outlined,
              color: Colors.white,
              size: 35,
            ),
            label: 'Lector',
          ),
          NavigationDestination(
            icon: Icon(
              pageIndex == 1 ? Icons.qr_code_scanner_rounded : Icons.qr_code,
              color: Colors.white,
              size: 35,
            ),
            label: 'Generador',
          )
        ],
      ),
    );
  }
}

class QrReader extends StatefulWidget {
  const QrReader({Key? key}) : super(key: key);

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  TextEditingController textController = TextEditingController();
  ScanResult scanResult = ScanResult();

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan();
      setState(() {
        scanResult = result;
        textController.text = scanResult.rawContent.toString();
        scanResult = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(scanResult.type.toString() ?? "1");
    print(scanResult.rawContent.toString() ?? "2");
    print(scanResult.format.toString() ?? "3");
    print(scanResult.formatNote.toString() ?? "4");
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              suffixIcon: IconButton(icon: const Icon(Icons.camera_alt), onPressed: _scan),
            ),
          ),
        ),
      ),
    );
  }
}

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key}) : super(key: key);

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              TextFormField(
                controller: textController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Container(
                padding: EdgeInsets.all(32),
                //   decoration: BoxDecoration(border: Border.all(width: 5, color: Colors.black)),
                child: BarcodeWidget(
                  height: 200,
                  width: 300,
                  barcode: Barcode.qrCode(), // Barcode type and settings
                  data: textController.text, // Content
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
