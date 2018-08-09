//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_convert;

import "dart:async";
import "dart:convert";
import 'package:test/test.dart';
import "package:rikulo_commons/convert.dart";

main() {
  group("io tests", () {
    test("stream to json", () {
      final val = {"abc": 123, "foo": ["this", "is", 200]};
      final list = utf8.encode(json.encode(val));
      return readAsJson(new Stream.fromIterable([list]))
      .then((got) {
        expect(got, val);
      });
    });
  });
}