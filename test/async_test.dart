//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Mar 27, 2013  9:19:55 AM
// Author: tomyeh
library test_async;

import "dart:async";
import 'package:test/test.dart';
import "package:rikulo_commons/async.dart";

main() {
  group("async tests", () {
    test("defer 1", () {
      int count = 0;
      for (int i = 0; i < 10; ++i)
        defer("foo", (key) {
          assert(key == "foo");
          ++count;
        }, min: const Duration(milliseconds: 100));
      return Future.delayed(const Duration(milliseconds: 200), () {
        expect(count, 1); //shall be only once
      });
    });

    test("defer 2", () {
      int count = 0, loop = 5;
      void add() {
        Future.delayed(const Duration(milliseconds: 30), () {
          defer("foo", (key) {
            assert(key == "foo");
            ++count;
          }, min: const Duration(milliseconds: 50),
             max: const Duration(milliseconds: 100));
          if (--loop >= 0)
            add();
        });
      }
      add();

      return Future.delayed(const Duration(milliseconds: 300), () {
        expect(count, 2);
      });
    });

    test("flush defer", () {
      int value = 0;
      defer("foo", (_) {
        return Future.delayed(const Duration(milliseconds: 300),
          () => value = 1);
      }, min: Duration.zero);

      //Wait again, so the previous defer() will be fired
      //before flushDefers() is called
      return Future.delayed(const Duration(milliseconds: 10), () async {
        await flushDefers();
        expect(value, 1);
      });
    });
  });
}
