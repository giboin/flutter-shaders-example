import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow_stuff_with_flutter/shader_mask/view/shader_mask_page.dart';

void main() {
  testWidgets('shader mask page contains hello world', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShaderMaskPage()));
    await tester.pumpAndSettle();
    expect(find.text('hello world'), findsOneWidget);
  });

  test('this test should fails', () => expect(1, 2));
}
