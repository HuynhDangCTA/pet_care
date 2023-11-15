import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  static Future setUser(UserResponse user) async {
    final shared = await sharedPreferences;
    await shared.setString(Constants.users, jsonEncode(user.toMap()));
  }

  static Future setString(String key, String value) async {
    final shared = await sharedPreferences;
    await shared.setString(key, value);
  }

  static Future<UserResponse?> getUser() async {
    final shared = await sharedPreferences;
    String? userString = shared.getString(Constants.users);
    if (userString == null || userString.isEmpty) return null;
    UserResponse user =
        UserResponse.fromMap(jsonDecode(userString) as Map<String, dynamic>);
    user.id = jsonDecode(userString)['id'];
    debugPrint('user pref ${user.toMap().toString()}');
    return user;
  }

  static Future removeUser() async {
    final shared = await sharedPreferences;
    await shared.remove(Constants.users);
  }
}
