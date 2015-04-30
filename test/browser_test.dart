//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, May 24, 2013  2:19:40 PM
// Author: tomyeh
library test_browser;

import 'package:test/test.dart';
import "package:rikulo_commons/browser.dart";

main() {
  group("browser tests", () {
    test("browser tests", () {
      Browser browser = new _Browser();
      expect(browser.chrome, isTrue);
      expect(browser.firefox, isFalse);
      expect(browser.name, "chrome");
      expect(browser.version, 26.0);
      expect(browser.dart, isTrue);
    });
  });
}

class _Browser extends Browser {
  String get userAgent => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 (Dart) Safari/537.31";
}
