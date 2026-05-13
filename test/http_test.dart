//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:37:47 PM
// Author: tomyeh
library test_http;

import "dart:async";
import "dart:convert";
import "dart:io" show ContentType;
import 'package:test/test.dart';
import "package:rikulo_commons/io.dart";
import "package:rikulo_commons/util.dart";

void main() {
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
      final request = Stream.fromIterable([utf8.encode(queryString)]);
      return HttpUtil.decodePostedParameters(request).then((params) {
        expect(HttpUtil.encodeQuery(params), queryString);
      });
    });

    test("decodeQuery splits on first '='", () {
      expect(HttpUtil.decodeQuery("foo=bar=baz"), {"foo": "bar=baz"});
      expect(HttpUtil.decodeQuery("token=abc=="), {"token": "abc=="});
      expect(HttpUtil.decodeQuery("a=1=2&b=x"), {"a": "1=2", "b": "x"});
    });

    test("decodeQuery edge cases", () {
      expect(HttpUtil.decodeQuery(""), <String, String>{});
      expect(HttpUtil.decodeQuery("foo"), {"foo": ""});
      expect(HttpUtil.decodeQuery("foo="), {"foo": ""});
      expect(HttpUtil.decodeQuery("=bar"), {"": "bar"});
      expect(HttpUtil.decodeQuery("a=1&b=2"), {"a": "1", "b": "2"});
      expect(HttpUtil.decodeQuery("a=1;b=2"), {"a": "1", "b": "2"});
      expect(HttpUtil.decodeQuery("name=value&"), {"name": "value"});
      expect(HttpUtil.decodeQuery("hello+world=x+y"), {"hello world": "x y"});
      expect(HttpUtil.decodeQuery("%26amp=%3D"), {"&amp": "="});
    });

    test("decodeQuery merges into existing map", () {
      final existing = {"old": "value"};
      final result = HttpUtil.decodeQuery("new=item", parameters: existing);
      expect(identical(result, existing), isTrue);
      expect(existing, {"old": "value", "new": "item"});
    });

    test("encodeQuery edge cases", () {
      expect(HttpUtil.encodeQuery({}), "");
      expect(HttpUtil.encodeQuery({"a": null}), "a=");
      expect(HttpUtil.encodeQuery({"a": ""}), "a=");
      expect(HttpUtil.encodeQuery({"flag": true, "off": false}),
          "flag=true&off=false");
      expect(HttpUtil.encodeQuery({"a&b": "c=d"}), "a%26b=c%3Dd");
    });

    test("contentType", () {
      var ctype = getContentType("html")!;
      expect(ctype, isNotNull);
      expect(ctype.charset, "utf-8");
      expect(identical(ctype, parseContentType(ctype.toString())), isTrue);
      expect(identical(ctype, ContentType.parse(ctype.toString())), isFalse);

      expect(getContentType("jpg")!.charset, isNull);

      expect(getMimeType('new.xml'), 'application/xml; charset=utf-8');
      expect(getMimeType('new.xml', autoUtf8: false), 'application/xml');
      expect(getMimeType('xml'), 'application/xml; charset=utf-8');

      expect(getMimeType('block/new.xml?ab.def'), 'application/xml; charset=utf-8');
    });

    final redundancy = validateMimeTypes(); //validate if any redundancy
    if (redundancy.isNotEmpty)
      print("Redundancy: ${redundancy.join(', ')}");
 });
}
