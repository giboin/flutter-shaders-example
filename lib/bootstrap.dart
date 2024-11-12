import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';

Future<void> bootstrap(
    FutureOr<Widget> Function(FragmentShader shader) builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final fragmentProgram = await FragmentProgram.fromAsset('shaders/green.frag');

  await runZonedGuarded(
    () async => runApp(await builder(fragmentProgram.fragmentShader())),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
