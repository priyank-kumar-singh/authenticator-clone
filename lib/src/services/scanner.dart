import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/app.dart';
import 'sql.dart';

Future<void> addNewApplication() async {
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

  var fData = Applications(
    user: data['user'] as String,
    type: data['type'] as String,
    secret: data['secret'] as String,
    issuer: data['issuer'] as String,
    algorithm: data['algorithm'] ?? 'SHA1',
    digits: data['digits'] ?? '6',
    counter: data['counter'] ?? '',
    period: data['period'] ?? '30',
  );

  if (fData.nullCheck()) {
    throw 'Invalid QR Code.';
  }

  var copy = await sqlDatabase.get(fData);
  if (copy.isNotEmpty) {
    throw 'Application already added.';
  }

  await sqlDatabase.add(fData);
}
