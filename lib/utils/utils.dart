import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Need to pass it in the [MaterialApp] of your
/// Sort Form of
/// ```dart
///  MaterialApp(
///    navigatorKey: gKey, <-
///  )
/// ```
final globalKey = GlobalKey<NavigatorState>();
final globalContext = globalKey.currentContext;

/// Sort Form of
/// ```dart
/// Navigator.of(context)
///      .push<T>(CupertinoPageRoute(builder: (_) => screen))
/// ```
Future<T?> push<T>({
  required BuildContext context,
  required Widget screen,
  bool pushUntil = false,
}) {
  if (pushUntil) {
    return Navigator.of(context).pushAndRemoveUntil<T?>(
        CupertinoPageRoute(builder: (_) => screen),
        (Route<dynamic> route) => false);
  }
  return Navigator.of(context)
      .push<T>(CupertinoPageRoute(builder: (_) => screen));
}

/// It is an short form of the
void pop<T>(BuildContext context, {T? result}) =>
    Navigator.of(context).pop<T>(result);

/// This method is used to pop to specific screen by passing value in [count]
void popTill<T>(BuildContext context, int count, {T? result}) {
  for (int i = 1; i <= count; i++) {
    Navigator.of(context).pop<T>(result);
  }
}

/// Pop to first screen of the navigator stack
void popToFirst(BuildContext context) {
  Navigator.of(context).pop((_) => _.isFirst);
}

/// BorderRadius Utils
BorderRadius radius(double radius) {
  return BorderRadius.circular(radius);
}

/// This method is used to print JSON response in formatted way
String getJson(jsonObject, {name}) {
  var encoder = const JsonEncoder.withIndent("     ");
  log(encoder.convert(jsonObject), name: name ?? "");
  return encoder.convert(jsonObject);
}

/// Method to give width
SizedBox width(double w) {
  return SizedBox(
    width: w,
  );
}

/// Method to give height
SizedBox height(double h) {
  return SizedBox(
    height: h,
  );
}

/// Loading Indicator
/// Before using this method you need to pass [EasyLoading.init()] in the material app
/// ```dart
///  MaterialApp(
///    builder: EasyLoading.init(), <-
///  )
/// ```
void loading({
  required bool value,
  String? title,
  bool closeOverlays = false,
}) {
  final primaryColor = Theme.of(globalContext!).primaryColor;
  if (value) {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..maskColor = primaryColor.withOpacity(.5)

      /// custom style
      ..loadingStyle = EasyLoadingStyle.custom
      ..progressColor = primaryColor
      ..indicatorColor = primaryColor
      ..backgroundColor = Colors.white
      ..textColor = Colors.black

      ///
      ..userInteractions = false
      ..animationStyle = EasyLoadingAnimationStyle.offset;
    EasyLoading.show(
      maskType: EasyLoadingMaskType.custom,
      status: "Loading..",
      dismissOnTap: kDebugMode,
    );
  } else {
    EasyLoading.dismiss();
  }
}
