class Applications {
  final int? uid;
  final String? type;
  final String? user;
  final String? secret;
  final String? issuer;
  final String algorithm;
  final String digits;
  final String counter;
  final String period;

  Applications({
    this.uid,
    required this.type,
    required this.user,
    required this.secret,
    required this.issuer,
    this.algorithm = 'SHA1',
    this.digits = '6',
    this.counter = '0',
    this.period = '30',
  });

  bool nullCheck() {
    if (user == null || type == null || secret == null || issuer == null) {
      return true;
    }
    return false;
  }

  Map<String, Object> toMap() {
    return {
      "user": "$user",
      "type": "$type",
      "secret": "$secret",
      "issuer": "$issuer",
      "algorithm": algorithm,
      "digits": digits,
      "counter": counter,
      "period": period,
    };
  }

  static Applications fromMap(Map e) {
    return Applications(
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
}
