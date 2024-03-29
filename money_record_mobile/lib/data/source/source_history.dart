import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/api.dart';
import '../../config/app_request.dart';

class SourceHistory {
  static Future<Map> analysis(String idUser) async {
    String url = '${Api.history}/analysis.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    });
    if (responseBody == null) {
      return {
        'today': 0.0,
        'yesterday': 0.0,
        'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'month': {
          'income': 0.0,
          'outcome': 0.0,
        }
      };
    }

    return responseBody;
  }

  static Future<bool> add(BuildContext context, String idUser, String date,
      String type, String details, String total) async {
    String url = '${Api.history}/add.php';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
      'date': date,
      'type': type,
      'details': details,
      'total': total,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String()
    });
    if (responseBody == null) return false;
    if (responseBody['success']) {
      DInfo.dialogSuccess(context, 'Tambah History Berhasil');
      DInfo.closeDialog(context,
          durationBeforeClose: const Duration(seconds: 1));
    } else {
      if (responseBody['message'] == 'date') {
        DInfo.dialogError(context, 'History pernah dibuat');
        DInfo.closeDialog(context);
      } else {
        DInfo.dialogError(context, 'Gagal Ditambah');
        DInfo.closeDialog(context);
      }
    }
    return responseBody['success'];
  }
}
