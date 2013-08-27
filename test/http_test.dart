//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:37:47 PM
// Author: tomyeh
library test_http;

import "dart:async";
import "dart:convert" show UTF8;
import 'package:unittest/unittest.dart';
import "package:rikulo_commons/io.dart";

main() {
  group("http tests", () {
    test("query string 1", () {
      final params = {
        "first": "the first item",
        "second": null, //means not to sure at all
        "third": "",
        "fourth": "\tand\n&or=?",
      };
      expect(HttpUtil.encodeQuery(params),
        "first=the+first+item&second=&third=&fourth=%09and%0A%26or%3D%3F");

      params["second"] = "=&?";
      expect(HttpUtil.decodeQuery(HttpUtil.encodeQuery(params)), params);
    });

    test("query string 2", () {
      final params = {
        "first": 123, //test conversion
        "second": "\t"
      };
      expect(HttpUtil.encodeQuery(params),
        "first=123&second=%09");
    });

    test("posted parameters", () {
      final queryString = "first=123&second=%09";
      final request = new Stream.fromIterable([UTF8.encode(queryString)]);
      return HttpUtil.decodePostedParameters(request).then((params) {
        expect(HttpUtil.encodeQuery(params), queryString);
      });
    });
 });
}