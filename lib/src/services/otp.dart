import 'package:authenticator/application.dart';
import 'package:otp/otp.dart';

String generateOTP(MFA_Apps data) {
  return data.type.toLowerCase() == 'totp' ? getTOTP(data) : getHOTP(data);
}

String getTOTP(MFA_Apps data) {
  return OTP.generateTOTPCodeString(
    data.secret,
    DateTime.now().millisecondsSinceEpoch,
    interval: int.parse(data.period),
    length: int.parse(data.digits),
    isGoogle: true,
    algorithm: data.algorithm.toLowerCase() == 'sha1'
        ? Algorithm.SHA1
        : data.algorithm.toLowerCase() == 'sha256'
            ? Algorithm.SHA256
            : Algorithm.SHA512,
  );
}

String getHOTP(MFA_Apps data) {
  return OTP.generateHOTPCodeString(
    data.secret,
    int.parse(data.counter),
    length: int.parse(data.digits),
    algorithm: data.algorithm.toLowerCase() == 'sha1'
        ? Algorithm.SHA1
        : data.algorithm.toLowerCase() == 'sha256'
            ? Algorithm.SHA256
            : Algorithm.SHA512,
  );
}
