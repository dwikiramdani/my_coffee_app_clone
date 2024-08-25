import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Flavor { dev, prod }

class FlavorValues {
  FlavorValues(
      {@required this.baseUrl,
      @required this.clientId,
      @required this.appName,
      @required this.userAgent,
      @required this.alice,
      @required this.organizationId});
  final String? baseUrl;
  final int? clientId;
  final String? appName;
  final String? userAgent;
  final Alice? alice;
  final int? organizationId;
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues value;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(flavor, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.value);
  static FlavorConfig get instance => _instance!;

  static bool isProduction() => _instance!.flavor == Flavor.prod;
  static bool isDevelopment() => _instance!.flavor == Flavor.dev;
}
