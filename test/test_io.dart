//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_io;

import "dart:async";
import "dart:json";
import 'package:/unittest/unittest.dart';
import "package:rikulo_commons/io.dart";

void main() {
  test("decode/encode", () {
    final str = "abcdefg";
    expect(IOUtil.decode(IOUtil.encode(str)), str);
  });
  test("stream to json", () {
    final val = {"abc": 123, "foo": ["this", "is", 200]};
    final list = IOUtil.encode(stringify(val));
    IOUtil.readAsJson(new Stream.fromIterable([list]))
    .then((got) {
        expect(got, val);
    });
  });
}