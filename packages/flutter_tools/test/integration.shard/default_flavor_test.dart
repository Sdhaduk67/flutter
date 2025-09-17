// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@Tags(<String>['flutter-test-driver'])
library;

import 'package:flutter_tools/src/base/file_system.dart';

import '../src/common.dart';
import 'test_data/project.dart';
import 'test_driver.dart';
import 'test_utils.dart';

void main() {
  final Project project = _DefaultFlavorProject();
  late Directory tempDir;
  late FlutterTestTestDriver flutter;

  setUp(() async {
    tempDir = createResolvedTempDirectorySync('default_flavor_test.');
    await project.setUpIn(tempDir);
    flutter = FlutterTestTestDriver(tempDir);
  });

  tearDown(() async {
    tryToDelete(tempDir);
  });

  testWithoutContext('Reads "default-flavor" in "flutter test"', () async {
    await flutter.test();

    // Without an assertion, this test always passes.
    final int? exitCode = await flutter.done;
    expect(exitCode, 0, reason: 'flutter test failed with exit code $exitCode');
  });
}

final class _DefaultFlavorProject extends Project {
  @override
<<<<<<< HEAD
  final String main = r'''
=======
  final main = r'''
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
    // Irrelevant to this test.
    void main() {}
  ''';

  @override
<<<<<<< HEAD
  final String pubspec = r'''
=======
  final pubspec = r'''
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
  name: test
  environment:
    sdk: ^3.7.0-0

  flutter:
    default-flavor: dev

  dependencies:
    flutter:
      sdk: flutter
  dev_dependencies:
    flutter_test:
      sdk: flutter
  ''';

  @override
<<<<<<< HEAD
  final String test = r'''
=======
  final test = r'''
>>>>>>> d693b4b9dbac2acd4477aea4555ca6dcbea44ba2
    import 'package:flutter/services.dart';
    import 'package:flutter_test/flutter_test.dart';

    void main() {
      test('receives default-flavor with flutter test', () async {
        expect(appFlavor, 'dev');
      });
    }
  ''';
}
