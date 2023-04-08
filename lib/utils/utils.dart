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
///    navigatorKey: globalKey, <-
///  )
/// ```
final globalKey = GlobalKey<NavigatorState>();

/// This is global build context which can be used outside of an Sateless and Stateful Widget
///
/// Before using this you need to set globalKey
/// ```dart
///  MaterialApp(
///    navigatorKey: globalKey, //put here
///  )
/// ```
final globalContext = globalKey.currentContext;

/// A Dart function that pushes a new route onto the navigation stack, displaying the specified screen widget.
///
/// Parameters:
///   - context: the BuildContext associated with the current widget tree.
///   - screen: a Widget representing the screen to be displayed.
///   - pushUntil: an optional boolean value indicating whether the current route should be popped off the navigation stack before pushing the new route.
///
/// Returns:
///   A Future that completes with an optional generic value when the route is popped and the user returns to the previous screen.
///
/// Example usage:
///   // Pushes a new route onto the navigation stack, displaying the specified screen widget.
/// ```dart
/// push<MyScreen>(context: context, screen: MyScreen(), pushUntil: true)
/// ```
///
Future<T?> push<T>({
  required BuildContext context,
  required Widget screen,
  bool pushUntil = false,
}) {
  if (pushUntil) {
    return Navigator.of(context).pushAndRemoveUntil<T?>(
        CupertinoPageRoute(builder: (_) => screen), (Route<dynamic> route) => false);
  }
  return Navigator.of(context).push<T>(CupertinoPageRoute(builder: (_) => screen));
}

/// A Dart function that pops the current route off the navigation stack and returns an optional result.
///
/// Parameters:
///   - context: the BuildContext associated with the current widget tree.
///   - result: an optional generic value representing the result to be returned to the previous route.
///
/// Returns:
///   This function returns void, as it simply pops the current route off the navigation stack and returns an optional result.
///
/// Example usage:
/// // Pops the current route off the navigation stack and returns a String result.
/// ```dart
/// pop<String>(context, result: "Hello World!");
/// ```
void pop<T>(BuildContext context, {T? result}) => Navigator.of(context).pop<T>(result);

/// A Dart function that pops the current route off the navigation stack a specified number of times.
///
/// Parameters:
///   - context: the BuildContext associated with the current widget tree.
///   - count: an integer value representing the number of times to pop the current route off the navigation stack.
///   - result: an optional generic value representing the result to be returned to the previous route.
///
/// Returns:
///   This function returns void, as it simply pops the current route off the navigation stack a specified number of times.
///
/// Example usage:
/// ```dart
/// popTill<String>(context, 3, result: "Hello World!");
/// ```
/// Pops the current route off the navigation stack 3 times and returns a String result.
void popTill<T>(BuildContext context, int count, {T? result}) {
  for (int i = 1; i <= count; i++) {
    Navigator.of(context).pop<T>(result);
  }
}

/// Pop to first screen of the navigator stack
void popToFirst(BuildContext context) {
  Navigator.of(context).popUntil((_) => _.isFirst);
}

/// A Dart function that creates a new circular BorderRadius object with the given radius value.
///
/// Parameters:
///   - radius: a double value representing the radius of the circular BorderRadius to be created.
///
/// Returns:
///   A new circular BorderRadius object with the given radius value.
///
/// Example usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: radius(10.0),
///     color: Colors.grey[300],
///   ),
///   child: Text("Hello World!"),
/// )
/// ```
/// This code creates a Container widget with a circular border radius of 10.0 and a grey background color.
BorderRadius radius(double radius) {
  return BorderRadius.circular(radius);
}

/// A Dart function that takes a JSON-serializable object and returns a formatted JSON string.
/// The function also logs the formatted JSON string to the console with an optional label.
///
/// Parameters:
///   - jsonObject: the JSON-serializable object to be converted to a formatted JSON string.
///   - name: an optional string used as a label for the logged output.
///
/// Returns:
///   A formatted JSON string representing the input object.
///
/// Example usage:
/// ```dart
/// var myObject = {"foo": "bar"};
/// getJson(myObject, name: "My Object"); // logs formatted JSON string with label "My Object"
/// ```
String getJson(jsonObject, {name}) {
  var encoder = const JsonEncoder.withIndent("     ");
  log(encoder.convert(jsonObject), name: name ?? "");
  return encoder.convert(jsonObject);
}

/// A custom Flutter widget that creates a horizontal spacer or divider with a fixed height and variable width.
/// Useful for creating empty space between other widgets or dividing content horizontally.
///
/// Example usage:
/// ```dart
/// Width(width: 20.0) // creates a horizontal spacer with a width of 20.0
/// ```
class Width extends StatelessWidget {
  const Width({Key? key, required this.width}) : super(key: key);
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
    );
  }
}

/// A custom Flutter widget that creates a vertical spacer or divider with a fixed width and variable height.
/// Useful for creating empty space between other widgets or dividing content vertically.
///
/// Example usage:
/// ```dart
/// Height(height: 50.0) // creates a vertical spacer with a height of 50.0
/// ```
class Height extends StatelessWidget {
  const Height({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

/// A utility function that unfocuses the currently focused text input field in the given BuildContext.
///
/// Parameters:
///   - context: the BuildContext associated with the current widget tree.
///
/// Example usage:
/// // Unfocuses the currently focused text input field in the given BuildContext.
/// ```dart
/// unFocus(context);
/// ```
///
void unFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

extension MQ on BuildContext {
  /// Extension method for
  /// ```dart
  /// MediaQuery.of(this).size
  /// ```
  Size get screenSize => MediaQuery.of(this).size;

  /// Extension method for
  /// ```dart
  /// Theme.of(this)
  /// ```
  ThemeData get theme => Theme.of(this);
}

/// IMP: Before using this method you need to pass [EasyLoading.init()] in the material app
/// ```dart
///  MaterialApp(
///    builder: EasyLoading.init(), <-
///  )
/// ```
/// info: To change color of loading indicator and overlay
/// ```
///  colorScheme: ColorScheme.fromSwatch().copyWith(
///   primary: , //Set your color
/// ),
/// ```
void loading({
  required bool value,
  String? title,
  bool closeOverlays = false,
}) {
  final primaryColor = Theme.of(globalContext!).colorScheme.primary;
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
      status: title ?? "Loading..",
      dismissOnTap: kDebugMode,
    );
  } else {
    EasyLoading.dismiss();
  }
}
