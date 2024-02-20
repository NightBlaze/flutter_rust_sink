import 'dart:ffi';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_rust_sink/src/rust/api/actors/actors_manager.dart';
import 'package:flutter_rust_sink/src/rust/api/actors/color_box_actor.dart';
import 'package:flutter_rust_sink/src/rust/api/simple.dart';
import 'package:flutter_rust_sink/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  createLogStream().listen((message) {
    debugLog(message);
  });
  runApp(const MyApp());
}

debugLog(String message) {
  print(message);
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
  ColorBox? _colorBox = const ColorBox();

  ColorBoxContainerState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        _colorBox = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_colorBox != null) {
      return _colorBox!;
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
  final _actor = ColorBoxActor.newColorBoxActor();
  // Stream<ColorModel>? _actorSinkColorModel;
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

  void _changeColorSync() {
    var newColor = _actor.changeColor();
    debugLog("_changeColorSync: got new color ${newColor.description()}");
    setState(() {
      _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    });
  }

  void _changeColor() async {
    //   var newColor = await colorBoxChangeColor(actorId: _actorId);
    //   if (newColor == null) {
    //     debugLog("_changeColor: got null color");
    //     return;
    //   }
    //   debugLog("_changeColor: got new color ${newColor.description()}");
    //   setState(() {
    //     _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    //   });
  }

  void _changeColorSink() {
    // colorBoxChangeColorSink(actorId: _actorId).listen((newColor) async {
    //   _colorSinkCount++;
    //   debugLog(
    //       "$_actorId _changeColorSink number $_colorSinkCount: got new color ${newColor.description()}");
    // setState(() {
    //   _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
    // });
    //   // if (_colorSinkCount >= 10) {
    //   //   await colorBoxCancelChangeColorSink(actorId: _actorId);
    //   //   debugLog("_changeColorSink cancelled");
    //   // }
    // });
  }

  void _likeButtonDidPress() async {
    // var newLikesCount = await colorBoxLike(actorId: _actorId);
    // if (newLikesCount == null) {
    //   debugLog("_likeButtonDidPress: got null");
    //   return;
    // }
    // setState(() {
    //   _likesCount = newLikesCount;
    // });
  }

  ColorBoxState() {
    _actor.setColorSink().listen((newColor) {
      debugLog("setColorSink: got new color ${newColor.description()}");
      setState(() {
        _color = _getMaterialColor(newColor.red, newColor.green, newColor.blue);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _actor.startChangeColor();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await colorBoxNew(actorId: _actorId);
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _changeColorSync();
    });

    // Future.delayed(const Duration(milliseconds: 10000), () async {
    //   await _actor.stopChangeColor();
    // });
  }

  @override
  void deactivate() {
    debugLog("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugLog("dispose");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _actor.dispose();
    });
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
