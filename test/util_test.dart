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

  test("XmlUtil", () {
    expect(XmlUtil.encode("<abc>"), "&lt;abc&gt;");
    expect(XmlUtil.encode('<abc>&\'"'), "&lt;abc&gt;&amp;'&quot;");
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

    expect(XmlUtil.decode("&lt;abc&GT; and &amp;"), '<abc> and &');

    expect(XmlUtil.encode("<abc de  f   \ng", space: true),
      "&lt;abc de&nbsp; f&nbsp;&nbsp; \ng");
    expect(XmlUtil.encode("<abc de  f   \ngg", space: true, multiLine: true),
      "&lt;abc de&nbsp; f&nbsp;&nbsp; <br/>\ngg");

    final text = '<img src="foo"/>  <br/>';
    expect(XmlUtil.decode(XmlUtil.encode(text, space: true)), text);

    expect(XmlUtil.decode('&#39;&#34;&#x3C;'), '\'"<');
  });

  test("StringUtl", () {
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
}
