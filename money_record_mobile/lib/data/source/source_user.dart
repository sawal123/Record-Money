import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record_mobile/config/api.dart';
import 'package:money_record_mobile/config/app_request.dart';
import 'package:money_record_mobile/config/session.dart';
import 'package:money_record_mobile/data/model/user.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}/login.php';
    Map? responseBody =
        await AppRequest.post(url, {'email': email, 'password': password});
    if (responseBody == null) return false;
    if (responseBody['success']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }
    return responseBody['success'];
  }

  static Future<bool> register(
      String name, String email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String()
    });
    if (responseBody == null) return false;
    if (responseBody['success']) {
      DInfo.dialogSuccess(email as BuildContext, 'Berhasil Register');
      DInfo.closeDialog(email as BuildContext,
          durationBeforeClose: const Duration(seconds: 1));
    } else {
      if (responseBody['message'] == 'email') {
        DInfo.dialogError(email as BuildContext, 'Email');
        DInfo.closeDialog(email as BuildContext);
      }
    }
    return responseBody['success'];
  }
}
