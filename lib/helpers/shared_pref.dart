import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> getPref<T>(String prefKey, T defaultValue) async {
  final prefs = await SharedPreferences.getInstance();
  dynamic prefValue;
  if (defaultValue is bool) {
    prefValue = prefs.getBool(prefKey) ?? defaultValue;
  } else if (defaultValue is double) {
    prefValue = prefs.getDouble(prefKey) ?? defaultValue;
  } else if (defaultValue is int) {
    prefValue = prefs.getInt(prefKey) ?? defaultValue;
  } else if (defaultValue is String) {
    prefValue = prefs.getString(prefKey) ?? defaultValue;
  } else if (defaultValue is List<String>) {
    prefValue = prefs.getStringList(prefKey) ?? defaultValue;
  } else if (defaultValue is Map<String, dynamic>) {
    prefValue = jsonDecode(prefs.getString(prefKey)!) ?? defaultValue;
  } else {
    prefValue = prefs.get(prefKey) ?? defaultValue;
  }
  return prefValue;
}

Future<void> savePref<T>(String prefKey, T value) async {
  final prefs = await SharedPreferences.getInstance();
  if (value is bool) {
    await prefs.setBool(prefKey, value);
  } else if (value is double) {
    await prefs.setDouble(prefKey, value);
  } else if (value is int) {
    await prefs.setInt(prefKey, value);
  } else if (value is String) {
    await prefs.setString(prefKey, value);
  } else if (value is List<String>) {
    await prefs.setStringList(prefKey, value);
  } else if (value is Map<String, dynamic>) {
    await prefs.setString(prefKey, jsonEncode(value));
  } else {
    throw 'savePref: $value is not defined';
  }
}

Future<void> removePref(String prefKey) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(prefKey);
}

Future<void> debugLog(String logMessage) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var buildName = packageInfo.version;
  var message = "[EPERPUS SAAS - $buildName] : $logMessage";

  if (kDebugMode) {
    debugPrint(message);
  }
}

const authorization = 'authorization';
Future<void> setAuthorization(bool value) async {
  debugLog('setAuthorization: $value');
  await savePref(authorization, value);
}

Future<String?> getAuthorization() async {
  debugLog("getAuthorization");
  String value = await getPref(authorization, "");
  return value;
}

Future<void> deleteAuthorization() async {
  debugLog('deleteAuthorization');
  await removePref(authorization);
}

const showCaseDevice = 'show_case_device';
Future<void> setShowCaseDevice(bool value) async {
  debugPrint('setShowCaseDevice: $value');
  await savePref(showCaseDevice, value);
}

Future<bool?> getShowCaseDevice() async {
  bool value = await getPref(showCaseDevice, true);
  return value;
}

Future<void> deleteShowCaseDevice() async {
  debugPrint('removeToken');
  await removePref(showCaseDevice);
}

const initialAssets = 'initialAssets';
Future<void> setInitialAssets(Map<String, dynamic> value) async {
  debugLog('setInitialAssets: $value');
  await savePref(initialAssets.toString(), value);
}

Future<Map<String, dynamic>?> getInitialAssets() async {
  debugLog("getInitialAssets");
  String assetsAsString = await getPref(initialAssets, "");
  Map<String, dynamic>? value =
      assetsAsString.isNotEmpty ? jsonDecode(assetsAsString) : null;
  return value;
}

Future<void> deleteInitialAssets() async {
  debugLog('deleteInitialAssets');
  await removePref(initialAssets);
}

const isFreshInstall = 'isFreshInstall';
Future<void> setIsFreshInstall(bool value) async {
  debugLog('setIsFreshInstall: $value');
  await savePref(isFreshInstall, value);
}

Future<bool> getIsFreshInstall() async {
  debugLog("getIsFreshInstall");
  final bool value = await getPref(isFreshInstall, true);
  return value;
}

Future<void> deleteIsFreshInstall() async {
  debugLog('deleteIsFreshInstall');
  await removePref(isFreshInstall);
}

const userJWT = 'userJWT';
Future<void> setUserJWT(String value) async {
  debugLog('setUserJWT: $value');
  await savePref(userJWT, value);
}

Future<String> getUserJWT() async {
  final String value = await getPref(userJWT, "");
  debugLog("getUserJWT: $value");
  return value;
}

Future<void> deleteUserJWT() async {
  debugLog('deleteUserJWT');
  await removePref(userJWT);
}

//TODO: Implement for Android (implemented) and iOS
const watermark = 'watermark';
Future<void> setWatermark(String value) async {
  debugPrint('setWatermark: $value');
  await savePref(watermark, value);
}

Future<String?> getWatermark() async {
  String? value = await getPref(watermark, '');
  return value;
}

Future<void> deleteWatermark() async {
  debugPrint('deleteWatermark');
  await removePref(watermark);
}

const firebaseToken = 'firebaseToken';
Future<void> setFirebaseToken(String value) async {
  debugPrint('setFirebaseToken: $value');
  await savePref(firebaseToken, value);
}

Future<String?> getFirebaseToken() async {
  debugPrint('getFirebaseToken');
  String? value = await getPref(firebaseToken, '');
  return value;
}

Future<void> deleteFirebaseToken() async {
  debugPrint('deleteFirebaseToken');
  await removePref(firebaseToken);
}

const userName = 'userName';
Future<void> setUserName(String value) async {
  debugLog('setUserName: $value');
  await savePref(userName, value);
}

Future<String> getUserName() async {
  final String value = await getPref(userName, "");
  debugLog("getUserName: $value");
  return value;
}

Future<void> deleteUserName() async {
  debugLog('deleteUserName');
  await removePref(userName);
}

const userId = 'userId';
Future<void> setUserId(int value) async {
  debugLog('setUserId: $value');
  await savePref(userId, value);
}

Future<int> getUserId() async {
  final int value = await getPref(userId, 0);
  debugLog("getUserId: $value");
  return value;
}

Future<void> deleteUserId() async {
  debugLog('deleteUserId');
  await removePref(userId);
}

const borrowingRule = 'borrowingRule';
Future<void> setBorrowingRule(Map<String, dynamic> value) async {
  debugLog('setBorrowingRule: $value');
  await savePref(borrowingRule.toString(), value);
}

Future<Map<String, dynamic>?> getBorrowingRule() async {
  debugLog("getBorrowingRule");
  String ruleAsString = await getPref(borrowingRule, "");
  Map<String, dynamic>? value =
      ruleAsString.isNotEmpty ? jsonDecode(ruleAsString) : null;
  return value;
}

Future<void> deleteBorrowingRule() async {
  debugLog('deleteBorrowingRule');
  await removePref(borrowingRule);
}

const isDownloadInProgress = 'isDownloadInProgress';
Future<void> setIsDownloadInProgress(bool value) async {
  debugLog('setIsDownloadInProgress: $value');
  await savePref(isDownloadInProgress, value);
}

Future<bool> getIsDownloadInProgress() async {
  debugLog("getIsDownloadInProgress");
  bool isDownloading = await getPref(isDownloadInProgress, false);
  return isDownloading;
}

Future<void> deleteIsDownloadInProgress() async {
  debugLog('deleteIsDownloadInProgress');
  await removePref(isDownloadInProgress);
}

const navigationBarCache = "navigationBarCache";
Future<void> setNavigationBarCache(String value) async {
  debugLog('setNavigationBarCache: $value');
  await savePref(navigationBarCache, value);
}

Future<List<Map<String, dynamic>>> getNavigationBarCache() async {
  debugLog("getNavigationBarCache");
  final navigationBarAsString = await getPref(navigationBarCache, "");
  final List<Map<String, dynamic>> navigationBar =
      List<Map<String, dynamic>>.from(
    jsonDecode(navigationBarAsString),
  );
  return navigationBar;
}

Future<void> deleteNavigationBarCache() async {
  debugLog('deleteNavigationBarCache');
  await removePref(navigationBarCache);
}

const sessionName = 'sessionName';
Future<void> setSessionName(String value) async {
  debugPrint('setSessionName: $value');
  await savePref(sessionName, value);
}

Future<String?> getSessionName() async {
  debugPrint('getSessionName');
  String? value = await getPref(sessionName, '');
  return value;
}

Future<void> deleteSessionName() async {
  debugPrint('deleteSessionName');
  await removePref(sessionName);
}

const notificationCache = 'notificationCache';
Future<void> setNotificationCache(List<String> value) async {
  debugPrint('setNotificationCache: $value');
  await savePref(notificationCache, value);
}

Future<List<String>> geNotificationCache() async {
  debugPrint('geNotificationCache');
  List<String> value = await getPref(notificationCache, []);
  return value;
}

Future<void> deleteNotificationCache() async {
  debugPrint('deleteSessionName');
  await removePref(notificationCache);
}

const notificationTotal = 'notificationCache';
Future<void> setNotificationTotal(int value) async {
  debugPrint('setNotificationTotal: $value');
  await savePref(notificationTotal, value);
}

Future<List<String>> geNotificationTotal() async {
  debugPrint('geNotificationTotal');
  List<String> value = await getPref(notificationTotal, []);
  return value;
}

Future<void> deleteNotificationTotal() async {
  debugPrint('deleteNotificationTotal');
  await removePref(notificationTotal);
}