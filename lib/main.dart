import 'package:flutter/material.dart';
import 'package:flutter_rust_sink/src/rust/api/simple.dart';
import 'package:flutter_rust_sink/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge sink demo')),
        body: const Center(
          child: ColorBox(),
        ),
      ),
    );
  }
}

class ColorBox extends StatefulWidget {
  const ColorBox({super.key});

  @override
  createState() => ColorBoxState();
}

class ColorBoxState extends State<ColorBox> {
  MaterialColor _color = Colors.green;
  int _color_sink_count = 0;

  MaterialColor _getMaterialColor(int red, int green, int blue) {
    final color = Color.fromRGBO(red, green, blue, 1);

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }

  void _setColorSync() {
    var newColor = getRandomColorSync();
    print("_setColorSync: got new color ${newColor.description()}");
    setState(() {
      _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    });
  }

  void _setColorAsync() async {
    var newColor = await getRandomColorAsync();
    print("_setColorAsync: got new color ${newColor.description()}");
    setState(() {
      _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    });
  }

  void _setColorCallback() async {
    await getRandomColorCallback(dartCallback: (newColor) {
      print("_setColorCallback: got new color ${newColor.description()}");
      setState(() {
        _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
      });
    });
  }

  void _setColorSink() {
    getRandomColorSink().listen((newColor) {
      _color_sink_count++;
      print(
          "_setColorSink number $_color_sink_count: got new color ${newColor.description()}");
      setState(() {
        _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
      });
      if (_color_sink_count == 10) {
        cancelGetRandomColorSink();
        print("_setColorSink cancelled");
      }
    });
  }

  ColorBoxState() {
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   _setColorSync();
    // });

    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   _setColorAsync();
    // });

    // Future.delayed(const Duration(milliseconds: 1500), () {
    //   _setColorCallback();
    // });

    Future.delayed(const Duration(milliseconds: 500), () {
      _setColorSink();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
    );
  }
}
