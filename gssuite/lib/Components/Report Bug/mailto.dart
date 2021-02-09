import 'package:gssuite/apis/api.dart';
import 'package:url_launcher/url_launcher.dart';

mailto() async {
  final url = mail;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch';
  }
}
