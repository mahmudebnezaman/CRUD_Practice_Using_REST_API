import 'package:crud_practice_using_rest_api/app.dart';
import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const CRUD(),
    ),
  );
}
