//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_io;

import "dart:async";
import 'package:unittest/unittest.dart';
import "package:rikulo_commons/io.dart";

main() {
  group("io tests", () {
    test("gzip test", () {
      final buf = new StringBuffer();
      for (int i = 100; --i >= 0;)
        buf.write("this is a test for string");
      final source = buf.toString();
      final result = gzipString(source);
      expect(source.length / 10 > result.length, isTrue);
      expect(ungzipString(result), source);
    });
  });
}