//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_io;

import "dart:async";
import "dart:json";
import 'package:unittest/unittest.dart';
import "package:rikulo_commons/io.dart";

main() {
  group("io tests", () {
    test("decode/encode", () {
      final str = "abcdefg";
      expect(decodeString(encodeString(str)), str);
    });

    test("stream to json", () {
      final val = {"abc": 123, "foo": ["this", "is", 200]};
      final list = encodeString(stringify(val));
      return IOUtil.readAsJson(new Stream.fromIterable([list]))
      .then((got) {
        expect(got, val);
      });
    });

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