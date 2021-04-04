//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 4, 2021
// Author: tomyeh
library test_stream;

import "dart:async";
import 'package:test/test.dart';
import "package:rikulo_commons/async.dart";

void main() {
  group("StreamUtil.first", () {
    test("Case 1", () async {
      expect(await StreamUtil.first(nothing()), null);
      expect(await StreamUtil.first(one()), 1);
    });

    test("Case 2", () async {
      final v1 = await StreamUtil.first(two());
      expect(_twoSet, false);
      expect(v1, 7);
    });
  });
}

Stream<int> nothing() async* {
}

Stream<int> one() async* {
  yield 1;
}

Stream<int> two() async* {
  yield 7;
  await Future.delayed(const Duration(seconds: 1));
  _twoSet = true;
  yield 9;
}
bool _twoSet = false;
