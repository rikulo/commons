//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Feb 25, 2013  5:28:08 PM
// Author: tomyeh
library test_util;

import 'package:test/test.dart';
import "package:rikulo_commons/util.dart";

void main() {
  test("MapUtil", () {
    final map = MapUtil.parse('abc="first" xyz="second item"');
    expect(map["abc"], "first");
    expect(map["xyz"], "second item");
  });

  test("MapUtil.copy", () {
    // No filter -> copies everything.
    expect(MapUtil.copy({"a": 1, "b": 2}, <String, int>{}),
        {"a": 1, "b": 2});

    // With filter -> only matching entries.
    expect(MapUtil.copy({"a": 1, "b": 2, "c": 3}, <String, int>{},
        (k, v) => v! > 1),
        {"b": 2, "c": 3});

    // Filter rejecting all -> empty dest.
    expect(MapUtil.copy({"a": 1, "b": 2}, <String, int>{},
        (k, v) => false),
        isEmpty);
  });

  test("Color.parse", () {
    expect(Color.parse("#ffffff"), equals(white));
    expect(Color.parse("#fff"), white);
    expect(Color.parse("white"), white);
    expect(Color.parse("rgba(128, 50%, 25%, 10%)"), Color(128, 127, 63, 0.1));
    expect(Color.parse("rgb(128, 50%, 25%)"), Color(128, 127, 63));
    expect(Color.parse("hsl(128, 50%, 25%)"), HslColor(128, 0.5, 0.25));
    expect(Color.parse("hsla(128, 50%, 25%, 20%)"), HslColor(128, 0.5, 0.25, 0.2));
    expect(Color.parse("hsv(128, 50%, 25%)"), HsvColor(128, 0.5, 0.25));
    expect(Color.parse("hsva(128, 50%, 25%, 20%)"), HsvColor(128, 0.5, 0.25, 0.2));
  });

  test("Color.toString pads hex to two digits", () {
    expect(Color(0, 0, 0).toString(), "#000000");
    expect(Color(1, 2, 3).toString(), "#010203");
    expect(Color(255, 255, 255).toString(), "#ffffff");
    expect(Color(16, 17, 18).toString(), "#101112");
  });

  test("Color <-> HslColor primary conversions", () {
    expect(Color(255, 0, 0).hsl(), HslColor(0, 1, 0.5));
    expect(Color(0, 255, 0).hsl(), HslColor(120, 1, 0.5));
    expect(Color(0, 0, 255).hsl(), HslColor(240, 1, 0.5));
    expect(Color(0, 0, 0).hsl(), HslColor(0, 0, 0));
    expect(Color(255, 255, 255).hsl(), HslColor(0, 0, 1));
  });

  test("Color <-> HslColor round-trip", () {
    void check(int r, int g, int b) {
      final back = Color(r, g, b).hsl().rgb();
      expect(back.red.round(), r);
      expect(back.green.round(), g);
      expect(back.blue.round(), b);
    }
    check(128, 64, 200);
    check(50, 150, 250);
    check(0, 128, 64);
    check(200, 200, 0);
  });

  test("HslColor.hsv and HsvColor.hsl preserve color", () {
    // RGB -> HSV -> HSL -> RGB should preserve the color.
    final orig = Color(128, 64, 200);
    final back = orig.hsv().hsl().rgb();
    expect(back.red.round(), 128);
    expect(back.green.round(), 64);
    expect(back.blue.round(), 200);
  });

  test("XmlUtil", () {
    expect(XmlUtil.encode("<abc>"), "&lt;abc&gt;");
    expect(XmlUtil.encode('<abc>&\'"'), "&lt;abc&gt;&amp;&apos;&quot;");
    expect(XmlUtil.encode("<abc\nanother line", multiLine: true),
      "&lt;abc<br/>\nanother line");
    expect(XmlUtil.encode("<abc> </abc>\ta", pre: true),
      "&lt;abc&gt;&nbsp;&lt;/abc&gt;&nbsp;&nbsp;&nbsp;&nbsp;a");
    expect(XmlUtil.encode("a ", space: true), "a ");
    expect(XmlUtil.encode("a   ", space: true), "a&nbsp;&nbsp; ");

    expect(XmlUtil.encode(r"&amp;"), r"&amp;amp;");
    expect(XmlUtil.encode(r"&amp;", entity: true), r"&amp;");
    expect(XmlUtil.encode(r"\&amp;&#123;", entity: true), r"&amp;amp;&#123;");
    expect(XmlUtil.encode(r"\\&amp;&#X123A;\&#123;", entity: true), r"\&amp;&#X123A;&amp;#123;");
    expect(XmlUtil.encode(r"&amp;\a", entity: true), r"&amp;\a");

    expect(XmlUtil.decode("&lt;abc&GT; and &amp;&quot;&apos;"),
        '<abc> and &"\'');

    expect(XmlUtil.encode("<abc de  f   \ng", space: true),
      "&lt;abc de&nbsp; f&nbsp;&nbsp; \ng");
    expect(XmlUtil.encode("<abc de  f   \ngg", space: true, multiLine: true),
      "&lt;abc de&nbsp; f&nbsp;&nbsp; <br/>\ngg");

    final text = '<img src="foo"/>  <br/>';
    expect(XmlUtil.decode(XmlUtil.encode(text, space: true)), text);

    expect(XmlUtil.decode('&#39;&#34;&#x3C;'), '\'"<');
  });

  test("String", () {
    expect($whitespaces.length, 26);

    final segs = "1\n2\t3 4\v5".split(regexWhitespaces);
    expect(segs.length, 5);
    expect(segs[0], '1');
    expect(segs[4], '5');
    expect("ab\nde f".indexOf(regexWhitespaces), 2);
  });

  test("DateTimeComparator", () {
    final d1 = DateTime(2020, 5, 1),
      d2 = DateTime(2020, 5, 2);
    expect(d1 < d2, true);
    expect(d1 <= d2, true);
    expect(d1 < d1, false);
    expect(d1 <= d1, true);
    expect(d1 == d1, true);
    expect(d2 > d1, true);
    expect(d2 - Duration(hours: 24), d1);
    expect(d2 | d1, Duration(hours: 24));
  });

  test("getMimeType", () {
    expect(getMimeType('new.xml'), 'application/xml; charset=utf-8');
    expect(getMimeType('new.xml', autoUtf8: false), 'application/xml');
    expect(getMimeType('xml'), 'application/xml; charset=utf-8');
    expect(getMimeType('block/new.xml?ab.def'), 'application/xml; charset=utf-8');
  });

  test("getMimeType strips query at first '?'", () {
    expect(getMimeType("foo.js?return=https://x.com?p=1"),
        "text/javascript; charset=utf-8");
  });

  test("getMimeType uses corrected mappings for jfif and pko", () {
    expect(getMimeType("jfif"), "image/jpeg");
    expect(getMimeType("pko"), "application/vnd.ms-pkipko");
  });

  test("getMimeType resolves modern formats", () {
    expect(getMimeType("config.yaml"), "application/yaml; charset=utf-8");
    expect(getMimeType("docker-compose.yml"), "application/yaml; charset=utf-8");
    expect(getMimeType("song.opus"), "audio/opus");
    expect(getMimeType("manifest.mpd"), "application/dash+xml; charset=utf-8");
    expect(getMimeType("archive.tar.zst"), "application/zstd");
  });

  test("addMimeType registers custom extension", () {
    addMimeType("xyzabc", "application/x-test-xyzabc");
    expect(getMimeType("xyzabc"), "application/x-test-xyzabc");
    expect(getMimeType("file.xyzabc"), "application/x-test-xyzabc");
  });
}
