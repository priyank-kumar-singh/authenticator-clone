import 'package:url_launcher/url_launcher.dart';

import '../models/result.dart';

Future<Result> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
    return Result(code: ResultCode.success);
  } else {
    return Result(
        code: ResultCode.exception, message: 'Failed to open required app.');
  }
}
