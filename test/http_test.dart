//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:37:47 PM
// Author: tomyeh
library test_http;

import "dart:async";
import "dart:convert";
import 'package:test/test.dart';
import "package:rikulo_commons/io.dart";

void main() {
  group("http tests", () {
    test("query string 1", () {
      final params = {
        "first": "the first item",
        "second": null, //means not to sure at all
        "third": "",
        "fourth": "\tand\n&or=?",
      };
      expect(encodeQueryString(params),
        "first=the+first+item&second=&third=&fourth=%09and%0A%26or%3D%3F");

      params["second"] = "=&?";
      expect(decodeQueryString(encodeQueryString(params)), params);
    });

    test("query string 2", () {
      final params = {
        "first": 123, //test conversion
        "second": "\t"
      };
      expect(encodeQueryString(params),
        "first=123&second=%09");
    });

    test("posted parameters", () {
      final queryString = "first=123&second=%09";
      final request = Stream.fromIterable([utf8.encode(queryString)]);
      return decodePostedParameters(request).then((params) {
        expect(encodeQueryString(params), queryString);
      });
    });

    test("decodeQueryString splits on first '='", () {
      expect(decodeQueryString("foo=bar=baz"), {"foo": "bar=baz"});
      expect(decodeQueryString("token=abc=="), {"token": "abc=="});
      expect(decodeQueryString("a=1=2&b=x"), {"a": "1=2", "b": "x"});
    });

    test("decodeQueryString edge cases", () {
      expect(decodeQueryString(""), <String, String>{});
      expect(decodeQueryString("foo"), {"foo": ""});
      expect(decodeQueryString("foo="), {"foo": ""});
      expect(decodeQueryString("=bar"), {"": "bar"});
      expect(decodeQueryString("a=1&b=2"), {"a": "1", "b": "2"});
      expect(decodeQueryString("a=1;b=2"), {"a": "1", "b": "2"});
      expect(decodeQueryString("name=value&"), {"name": "value"});
      expect(decodeQueryString("hello+world=x+y"), {"hello world": "x y"});
      expect(decodeQueryString("%26amp=%3D"), {"&amp": "="});
    });

    test("decodeQueryString merges into existing map", () {
      final existing = {"old": "value"};
      final result = decodeQueryString("new=item", parameters: existing);
      expect(identical(result, existing), isTrue);
      expect(existing, {"old": "value", "new": "item"});
    });

    test("encodeQueryString edge cases", () {
      expect(encodeQueryString({}), "");
      expect(encodeQueryString({"a": null}), "a=");
      expect(encodeQueryString({"a": ""}), "a=");
      expect(encodeQueryString({"flag": true, "off": false}),
          "flag=true&off=false");
      expect(encodeQueryString({"a&b": "c=d"}), "a%26b=c%3Dd");
    });

    test("contentType", () {
      final ctype = getContentType("html")!;
      expect(ctype.charset, "utf-8");

      expect(getContentType("jpg")!.charset, isNull);
    });
  });
}
