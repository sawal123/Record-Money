import 'package:d_method/d_method.dart';
import 'package:http/http.dart';

class AppRequest {
  static Future<Map?> gets(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
    }
  }
}
