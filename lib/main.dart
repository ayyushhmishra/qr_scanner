import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false to remove the debug banner
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _isDialogShowing = false;
  Timer? _throttleTimer;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1CC), // Background color
      body: Column(
        children: <Widget>[
          const SizedBox(height: 80), // Spacing from top
          Center(
            child: Image.asset('assets/img.png', width: 150), // Logo image
          ),
          const SizedBox(height: 40),
          Expanded(flex: 4, child: _buildQrView(context)), // QR view
          const SizedBox(height: 40),
          const Text(
            'Scannen Sie den QR-Code', // Instruction text
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Scannen Sie den QR-Code auf der Unterseite des Gateways, um die Installation fortzusetzen', // Description text
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    return Center(
      child: Container(
        width: scanArea,
        height: scanArea,
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.black, // Border color
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea, // Size of the scan area
          ),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!_isDialogShowing && (_throttleTimer == null || !_throttleTimer!.isActive)) {
        setState(() {
          result = scanData;
          _isDialogShowing = true;
        });
        _showResultDialog(context, scanData.code);
      }
    });
  }

  void _showResultDialog(BuildContext context, String? code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scan Result'),
          content: Text(code ?? 'No code found'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isDialogShowing = false;
                  // Throttle next dialog to avoid rapid reopening
                  _throttleTimer = Timer(const Duration(seconds: 2), () {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')), // Show snackbar if permission not granted
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose the controller
    _throttleTimer?.cancel();
    super.dispose();
  }
}
