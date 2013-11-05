//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_io;

import "dart:io" show ContentType;
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

    test("contentType", () {
      var ctype = contentTypes["html"];
      expect(ctype, isNotNull);
      expect(identical(ctype, parseContentType(ctype.toString())), isTrue);
      expect(identical(ctype, ContentType.parse(ctype.toString())), isFalse);
    });
  });
}