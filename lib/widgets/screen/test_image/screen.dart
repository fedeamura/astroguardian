import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TestImageScreen extends StatefulWidget {
  const TestImageScreen({super.key});

  @override
  State<TestImageScreen> createState() => _TestImageScreenState();
}

class _TestImageScreenState extends State<TestImageScreen> {
  ui.Image? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _create,
            child: Text("Create"),
          ),
          Expanded(
            child: _image != null
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: RawImage(
                      image: _image!,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  _create() {
    // const int w = 100;
    // const int h = 100;
    // final rgbaList = Uint8List(w * h * 4);
    // final rnd = math.Random();
    // for (var i = 0; i < w * h; i++) {
    //   final rgbaOffset = i * 4;
    //   rgbaList[rgbaOffset] = (rnd.nextDouble() * 255).floor(); // red
    //   rgbaList[rgbaOffset + 1] = (rnd.nextDouble() * 255).floor(); // green
    //   rgbaList[rgbaOffset + 2] = (rnd.nextDouble() * 255).floor(); // blue
    //   rgbaList[rgbaOffset + 3] = 255; // a
    // }
    //
    // ui.decodeImageFromPixels(rgbaList, w, h, ui.PixelFormat.rgba8888, (result) {
    //   setState(() {
    //     _image = result;
    //   });
    // });

    const int w = 1;
    const int h = 100;
    final rgbaList = Uint8List(w * h * 4);

    for (int i = 0; i < h; i++) {
      final rgbaOffset = i * 4;
      rgbaList[rgbaOffset] = 255;
      rgbaList[rgbaOffset + 1] = 255;
      rgbaList[rgbaOffset + 2] = 255;
      rgbaList[rgbaOffset + 3] = 255;
    }

    ui.decodeImageFromPixels(rgbaList, w, h, ui.PixelFormat.rgba8888, (result) {
      setState(() {
        _image = result;
      });
    });
  }
}
