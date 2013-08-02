//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_io;

import "dart:async";
import 'package:unittest/unittest.dart';
import "package:rikulo_commons/async.dart";

main() {
  group("async tests", () {
    test("defer", () {
      int count = 0;
      for (int i = 0; i < 10; ++i)
        defer("foo", () {++count;}, min: const Duration(milliseconds: 100));
      return new Future.delayed(const Duration(milliseconds: 200), () {
        expect(count, 1); //shall be only once
      });
    });
  });
}
