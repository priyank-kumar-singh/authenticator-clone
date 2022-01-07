import 'dart:convert';
import 'dart:typed_data';

import 'package:authenticator/application.dart';
import 'package:base32/encodings.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

String generateOTP(Applications data) {
  return data.type?.toLowerCase() == 'totp' ? getTOTP(data) : getHOTP(data);
}

String encodeBase32(String str) {
  var secret = base32.encode(Uint8List.fromList(utf8.encode(str)), encoding: Encoding.standardRFC4648);
  // print("Original = $str");
  // print("Base32 = $secret");
  return secret;
}

String getTOTP(Applications data) {
  return OTP.generateTOTPCodeString(
      encodeBase32(data.secret!),
      DateTime.now().millisecondsSinceEpoch,
      algorithm: data.algorithm.toLowerCase() == 'sha1'
          ? Algorithm.SHA1
          : data.algorithm.toLowerCase() == 'sha256'
              ? Algorithm.SHA256
              : Algorithm.SHA512,
    );
}

String getHOTP(Applications data) {
  //TODO: HOTP
  return 'HOTP Implementation Remaining';
}
