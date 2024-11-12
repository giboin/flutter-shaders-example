import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:glow_stuff_with_flutter/app/view/app.dart';

Future<void> bootstrap() async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final fragmentProgram =
      await FragmentProgram.fromAsset('shaders/gradient.frag');

  await runZonedGuarded(
    () async => runApp(App(shader: fragmentProgram.fragmentShader())),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
