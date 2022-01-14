import 'dart:convert';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/app.dart';
import 'sql.dart';

class Scanner {
  Scanner._();

  static Future<void> addApplication() async {
    var res = await FlutterBarcodeScanner.scanBarcode(
        "#ff0000", "Cancel", false, ScanMode.QR);

    if (res == "" || res == '-1') {
      return;
    }

    var check = res.substring(0, res.indexOf(':'));
    if (check != 'otpauth') {
      throw 'Invalid QR Code.';
    }

    var uri = Uri.parse(res);
    var user = Uri.decodeComponent(uri.path);
    var data = {
      "user": user.substring(user.indexOf(':') + 1),
      "type": uri.host,
    };
    uri.queryParameters.forEach((key, value) {
      data.addAll({key: value});
    });

    var fData = createObject(data);

    var copyCheck = await sqlDatabase.getOne(fData);
    if (copyCheck.isNotEmpty) {
      throw 'Application already added.';
    }

    await sqlDatabase.add(fData);
  }

  static Future<bool> importApps() async {
    var res = await FlutterBarcodeScanner.scanBarcode(
        "#ff0000", "Cancel", false, ScanMode.QR);

    if (res == "" || res == '-1') {
      return false;
    }

    var data = jsonDecode(res) as List<Map<String, String>>;
    for (var obj in data) {
      var fData = createObject(obj);
      var copyCheck = await sqlDatabase.getOne(fData);
      if (copyCheck.isEmpty) {
        await sqlDatabase.add(fData);
      }
    }
    return true;
  }

  static MFA_Apps createObject(Map<String, String> data) {
    return MFA_Apps(
      user: data['user']!,
      type: data['type']!,
      secret: data['secret']!,
      issuer: data['issuer']!,
      algorithm: data['algorithm'] ?? MFA_Apps.dAlgorithm,
      digits: data['digits'] ?? MFA_Apps.dDigits,
      counter: data['counter'] ?? MFA_Apps.dCounter,
      period: data['period'] ?? MFA_Apps.dPeriod,
    );
  }
}
