//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:37:47 PM
// Author: tomyeh
library test_http;

import "dart:async";
import 'package:/unittest/unittest.dart';
import "package:rikulo_commons/io.dart";

main() {
  group("http tests", () {
    test("query string", () {
      final params = {
        "first": "the first item",
        "second": null, //means not to sure at all
        "third": "",
        "fourth": "\tand\n&or=?",
      };
      expect(HttpUtil.encodeQueryString(params),
        "first=the+first+item&second=&third=&fourth=%09and%0A%26or%3D%3F");

      params["second"] = "=&?";
      expect(HttpUtil.decodeQueryString(HttpUtil.encodeQueryString(params)), params);
    });
 });
}