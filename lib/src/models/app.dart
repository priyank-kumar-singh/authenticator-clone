// ignore: camel_case_types
class MFA_Apps {
  final int? uid;
  final String type;
  final String user;
  final String secret;
  final String issuer;
  final String algorithm;
  final String digits;
  final String counter;
  final String period;

  static const String dType = 'totp';
  static const String dAlgorithm = 'sha1';
  static const String dDigits = '6';
  static const String dCounter = '0';
  static const String dPeriod = '30';

  MFA_Apps({
    this.uid,
    required this.type,
    required this.user,
    required this.secret,
    required this.issuer,
    required this.algorithm,
    required this.digits,
    required this.counter,
    required this.period,
  });

  Map<String, Object> toMap() {
    return {
      "user"  : user,
      "type"  : type,
      "secret": secret,
      "issuer": issuer,
      "algorithm": algorithm,
      "digits"  : digits,
      "counter" : counter,
      "period"  : period,
    };
  }

  static MFA_Apps fromMap(Map e) {
    return MFA_Apps(
      uid: e['uid'] as int,
      user: e['user'] as String,
      type: e['type'] as String,
      secret: e['secret'] as String,
      issuer: e['issuer'] as String,
      algorithm: e['algorithm'] as String,
      digits: e['digits'] as String,
      counter: e['counter'] as String,
      period: e['period'] as String,
    );
  }

  @override
  String toString() {
    return "{uid: $uid, user: $user, type: $type, secret: $secret, issuer: $issuer, algorithm: $algorithm, digits: $digits, counter: $counter, period: $period}";
  }

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'user': user,
      'type': type,
      'secret': secret,
      'issuer': issuer,
      'algorithm': algorithm,
      'digits': digits,
      'counter': counter,
      'period': period,
    };
  }
}
