import 'dart:convert';

import 'package:authenticator/application.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<MFA_Apps> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Scan the QR Code below with another device by chosing the import option...'),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 250,
                maxHeight: 250,
              ),
              child: SfBarcodeGenerator(value: jsonEncode(data), symbology: QRCode()),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
