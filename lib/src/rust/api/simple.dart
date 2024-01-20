// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.20.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

String greet({required String name, dynamic hint}) =>
    RustLib.instance.api.greet(name: name, hint: hint);

Future<ColorModel> getRandomColorAsync({dynamic hint}) =>
    RustLib.instance.api.getRandomColorAsync(hint: hint);

ColorModel getRandomColorSync({dynamic hint}) =>
    RustLib.instance.api.getRandomColorSync(hint: hint);

Future<void> getRandomColorCallback(
        {required FutureOr<void> Function(ColorModel) dartCallback,
        dynamic hint}) =>
    RustLib.instance.api
        .getRandomColorCallback(dartCallback: dartCallback, hint: hint);

Stream<ColorModel> getRandomColorSink({dynamic hint}) =>
    RustLib.instance.api.getRandomColorSink(hint: hint);

void cancelGetRandomColorSink({dynamic hint}) =>
    RustLib.instance.api.cancelGetRandomColorSink(hint: hint);

class ColorModel {
  final int red;
  final int green;
  final int blue;

  const ColorModel({
    required this.red,
    required this.green,
    required this.blue,
  });

  String description({dynamic hint}) =>
      RustLib.instance.api.colorModelDescription(
        that: this,
      );

  @override
  int get hashCode => red.hashCode ^ green.hashCode ^ blue.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorModel &&
          runtimeType == other.runtimeType &&
          red == other.red &&
          green == other.green &&
          blue == other.blue;
}
