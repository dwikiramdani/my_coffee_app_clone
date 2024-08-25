import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

String getHashedPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha1.convert(bytes);

  return "$digest";
}

Future<void> showNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your_channel_id', 'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
}

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    // Permission is granted
    debugPrint('Storage permission granted.');
  } else if (status.isDenied) {
    // Permission is denied
    debugPrint('Storage permission denied.');
  } else if (status.isPermanentlyDenied) {
    // Permission is permanently denied, open app settings
    debugPrint('Storage permission permanently denied.');
    openAppSettings();
  }
}

Future<bool?> getConnectionInternetStatus() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return null;
}