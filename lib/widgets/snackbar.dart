import 'package:flutter/material.dart';

showErrorSnackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
