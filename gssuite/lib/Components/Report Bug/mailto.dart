import 'package:gssuite/apis/api.dart';
import 'package:url_launcher/url_launcher.dart';

mailto() async {
  print('mailto reached');
  final url = mail;
  if (await canLaunch(url)) {
    print("test url2");
    await launch(url);
  } else {
    print("test url3");
    throw 'Could not launch';
  }
}
