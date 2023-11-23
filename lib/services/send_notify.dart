import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_care/services/fcm_service.dart';

class SendNotify {
  static final Uri _uri = Uri.parse('https://fcm.googleapis.com/fcm/send');

  static Future sendNotifyFromMultipleUser(
      String title, String body, List<String> tokens) async {
    final response = await http.post(_uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${FCMService.key}',
        },
        body: jsonEncode({
          'registration_ids': tokens,
          'notification': {"body": body, "title": title}
        }));
  }

  static Future sendNotify(
      {required String token, required String title, required String body}) async {
    final response = await http.post(_uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=${FCMService.key}',
        },
        body: jsonEncode({
          'to': token,
          'notification': {"body": body, "title": title}
        }));
  }
}

// {
// "registration_ids": [
// "dVPbBiTQTTOyffXXhCGz5_:APA91bF7kEdHIbOPfPQQVtq1D-NilaRvOnZzrNMqfusdCd3sAMuWHf0Gp5OGj6Xi3wPmBkgetsd4nzVSejBpIiNGffDgZ67cMtp6OkrUrmdeb9blApik1mb_yIEnFaty3aXi8RlbUqZr",
// "fEIO9mA1RFy4MzFMdvmMvT:APA91bHguii69rimMN1s_VI13eCac-XsKIcsfVP2tdlvwN-sXKevdBj299vFkMEkzuOd9aG8-vcYmQzwrM7dJqeg-g31JCQQIdRez9aJaGenp-x90SRtyXRKjSAfXyPlhO2AP4KlEL7k"
// ],
// "notification": {
// "body": "Đơn hàng do khách hàng ABC đã tạo",
// "title": "Có đơn hàng mới cần xử lý"
// },
// "data": {
// "body": "nôi dung chi tiết",
// "title": "thông tin chi tiết",
// "key_1": "giá trị key_1",
// "key_2": "giá trị key_2"
// }
// }
