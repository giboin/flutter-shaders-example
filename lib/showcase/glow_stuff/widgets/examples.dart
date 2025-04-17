import 'dart:io';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:rive/rive.dart';

class TextEditableExample extends StatefulWidget {
  const TextEditableExample({super.key});

  @override
  State<TextEditableExample> createState() => _TextEditableExampleState();
}

class _TextEditableExampleState extends State<TextEditableExample> {
  late final _contoller = TextEditingController(text: 'Glowing text');
  late final _focusNode = FocusNode();

  @override
  void dispose() {
    _contoller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 36),
      child: Center(
        child: EditableText(
          controller: _contoller,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFFFFFF),
            letterSpacing: Platform.isAndroid ? -1 : -12,
            fontSize: Platform.isAndroid ? 40 : 140,
            height: 0.9,
          ),
          cursorColor: Colors.white,
          backgroundCursorColor: Colors.orange,
          selectionColor: Colors.orange,
        ),
      ),
    );
  }
}

class ImageExample extends StatefulWidget {
  const ImageExample({super.key});

  @override
  State<ImageExample> createState() => _ImageExampleState();
}

class _ImageExampleState extends State<ImageExample> {
  final _controller = PhotoViewScaleStateController()
    ..scaleState = PhotoViewScaleState.originalSize;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 36),
        child: PhotoView(
          scaleStateController: _controller,
          imageProvider: const AssetImage('assets/jamesweb.jpg'),
        ),
      ),
    );
  }
}

class RiveExample extends StatefulWidget {
  const RiveExample({super.key});

  @override
  State<RiveExample> createState() => _RiveExampleState();
}

class _RiveExampleState extends State<RiveExample> {
  void _onRiveInit(Artboard artboard) {
    final controller =
        // ignore: avoid-non-null-assertion , rive's typesafety is forcing this
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    artboard.addController(controller);

    controller.isActive = true;

    controller.inputs.firstOrNull?.value = true;
  }

  late final _height = MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: ColoredBox(
        color: const Color(0xFF201620),
        child: Center(
          child: SizedBox.square(
            dimension: 900,
            child: RiveAnimation.asset(
              'assets/eye.riv',
              onInit: _onRiveInit,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class LongTextExample extends StatelessWidget {
  const LongTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 400, horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Darude - Sandstorm',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFFFFFF),
              letterSpacing: -6,
              fontSize: Platform.isAndroid ? 70 : 110,
              height: 0.9,
            ),
            selectionColor: Colors.orange,
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            '''
Duuuuuuuuuuuuuuuuuuuuuuun
dun dun dun dun dun dun dun dun dun dun dun
dundun dun dundundun dun dun dun dun dun dun
dundun dundun
BOOM
dundun dundun dundun
BEEP
dun dun dun dun dun
dun dun
BEEP BEEP BEEP BEEP
BEEEP BEEP BEEP BEEP
BEEP BEEP BEEP BEEP BEEP
BEEP BEEP BEEP BEEP BEEP BOOM
daddaddadadsadadadadadadadadada
dadadadadadaddadadaddadadadadad
adadadadadadaddadddadaddadadadd
dadadadaddaddadad
dadadddaddadaddadadadddadadada
nyu nyu nyu nyu nyu nnyu nyu nyu
nyu nyu nyu nyu nyu nyu nyu nyu
doo doo doo doo doo doo doo doo
nnn nn nn nn nn nn n nn nnn nn nn nnn nnn nnnnnnnn
dddddddd ddadadadadaddadadadadadaadadadadadad
BOOM
nyu nyu nyu nyu nyu nyu
BOOM
BOOM BOOM BOOM BOOM
BOOM''',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFFFFFFFF),
              letterSpacing: -1,
              fontSize: 24,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
