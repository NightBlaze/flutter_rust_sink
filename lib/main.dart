import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rust_sink/src/rust/api/actors/actors_manager.dart';
import 'package:flutter_rust_sink/src/rust/api/actors/color_box_actor.dart';
import 'package:flutter_rust_sink/src/rust/api/simple.dart';
import 'package:flutter_rust_sink/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _getRow() {
    List<Widget> list = List.empty(growable: true);
    for (var i = 0; i < 1; i++) {
      list.add(
        const Padding(
          padding: EdgeInsets.all(2),
          child: ColorBoxContainer(),
        ),
      );
    }
    return Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge sink demo')),
        body: Center(
          child: Column(
            children: [
              _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
              // _getRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorBoxContainer extends StatefulWidget {
  const ColorBoxContainer({super.key});

  @override
  createState() => ColorBoxContainerState();
}

class ColorBoxContainerState extends State<ColorBoxContainer> {
  bool _isVisible = true;

  ColorBoxContainerState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isVisible) {
      return const ColorBox();
    } else {
      return SizedBox(
        width: 50,
        height: 50,
        child: Container(
          color: Colors.amber,
        ),
      );
    }
  }
}

class ColorBox extends StatefulWidget {
  const ColorBox({super.key});

  @override
  createState() => ColorBoxState();
}

class ColorBoxState extends State<ColorBox> {
  final _actorId = generateActorId();
  MaterialColor _color = Colors.green;
  String _likesCount = "0";
  int _colorSinkCount = 0;

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

  void _changeColor() async {
    var newColor = await colorBoxChangeColor(actorId: _actorId);
    if (newColor == null) {
      print("_changeColor: got null color");
      return;
    }
    print("_changeColor: got new color ${newColor.description()}");
    setState(() {
      _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    });
  }

  void _changeColorSink() {
    colorBoxChangeColorSink(actorId: _actorId).listen((newColor) async {
      _colorSinkCount++;
      print(
          "$_actorId _changeColorSink number $_colorSinkCount: got new color ${newColor.description()}");
      setState(() {
        _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
      });
      // if (_colorSinkCount >= 10) {
      //   await colorBoxCancelChangeColorSink(actorId: _actorId);
      //   print("_changeColorSink cancelled");
      // }
    });
  }

  void _likeButtonDidPress() async {
    var newLikesCount = await colorBoxLike(actorId: _actorId);
    if (newLikesCount == null) {
      print("_likeButtonDidPress: got null");
      return;
    }
    setState(() {
      _likesCount = newLikesCount;
    });
  }

  ColorBoxState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await colorBoxNew(actorId: _actorId);
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _changeColor();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _changeColorSink();
    });
  }

  @override
  void dispose() {
    print("dispose _actorId: $_actorId");
    colorBoxDelete(actorId: _actorId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Container(
        color: _color,
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
          ),
          onPressed: _likeButtonDidPress,
          child: Text(_likesCount),
        ),
      ),
    );
  }
}
