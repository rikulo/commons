//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, May 24, 2013  2:19:40 PM
// Author: tomyeh
library test_browser;

import 'package:test/test.dart';
import "package:rikulo_commons/browser.dart";

main() {
  void isChrome(Browser browser, num version) {
    expect(browser.chrome, isTrue);
    expect(browser.webkit, isTrue);
    expect(browser.firefox, isFalse);
    expect(browser.name, "chrome");
    expect(browser.version, version);
  }
  void isEdge(Browser browser, num version) {
    expect(browser.webkit, isTrue);
    expect(browser.edge, isTrue);
    expect(browser.ie, isFalse); //Edge is not IE
    expect(browser.chrome, isFalse);
    expect(browser.firefox, isFalse);
    expect(browser.name, "edge");
    expect(browser.version, version);
  }
  void isIE(Browser browser, num version) {
    expect(browser.ie, isTrue);
    expect(browser.edge, isFalse);
    expect(browser.webkit, isFalse);
    expect(browser.chrome, isFalse);
    expect(browser.firefox, isFalse);
    expect(browser.name, "ie");
    expect(browser.version, version);
  }
  void isSafari(Browser browser, num version) {
    expect(browser.safari, isTrue);
    expect(browser.webkit, isTrue);
    expect(browser.chrome, isFalse);
    expect(browser.firefox, isFalse);
    expect(browser.name, "safari");
    expect(browser.version, version);
  }
  void isFirefox(Browser browser, num version) {
    expect(browser.safari, isFalse);
    expect(browser.webkit, isFalse);
    expect(browser.chrome, isFalse);
    expect(browser.firefox, isTrue);
    expect(browser.name, "firefox");
    expect(browser.version, version);
  }
  void isOpera(Browser browser, num version) {
    expect(browser.safari, isFalse);
    expect(browser.webkit, isFalse);
    expect(browser.ie, isFalse);
    expect(browser.opera, isTrue);
    expect(browser.name, "opera");
    expect(browser.version, version);
  }
  void isWebkit(Browser browser, num version) {
    expect(browser.safari, isFalse);
    expect(browser.webkit, isTrue);
    expect(browser.version, version);
  }

  group("browser tests", () {
    test("browser tests", () {
      final Map<String, List> uas = {
"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36 Chrome 41.0.2227.1":
  [isChrome, 41.0],
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36 Chrome 41.0.2227.0":
  [isChrome, 41.0],
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36":
  [isChrome, 41.0],
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36":
  [isChrome, 41.0],

"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A":
  [isSafari, 7.0],
"Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25":
  [isSafari, 6.0],

"Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko":
  [isIE, 11.0],
"Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko":
  [isIE, 11.0],
"Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0":
  [isIE, 10.06],

"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246":
  [isEdge, 12.246],

"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1":
  [isFirefox, 40.01],
"Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0":
  [isFirefox, 36.0],

"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16":
  [isOpera, 12.16],
"Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14":
  [isOpera, 12.14],
"Mozilla/5.0 (Windows NT 6.0; rv:2.0) Gecko/20100101 Firefox/4.0 Opera 12.14":
  [isOpera, 12.14],
"Xiaomi_MDT2_TD-LTE/V1 Linux/3.18.31 Android/7.1 Release/5.15.2017 "
"Browser/AppleWebKit537.36 Mobile Safari/537.36 System/Android 7.1 XiaoMi/MiuiBrowser/8.7.7":
  [isWebkit, 537.36],

//New Edge
newEdge:
  [isChrome, 83.0],
      };

      for (final ua in uas.keys) {
//        print(ua);
        final browser = _Browser(ua);
        final List result = uas[ua];
        result[0](browser, result[1]);
      }

      var browser = _Browser(newEdge);
      expect(browser.edge, isFalse);
      expect(browser.webkit, isTrue);
    });

    test("OS test", () {
      for (final ua in [
"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-en) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4",
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15",
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2"]) {
        expect(_Browser(ua).macOS, isTrue);
      }

      for (final ua in [
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
"Thunderstorm/1.0 (Linux)",
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/74.0.3729.157 Safari/537.36",
"Opera/9.80 (Linux armv7l) Presto/2.12.407 Version/12.51 , D50u-D1-UHD/V1.5.16-UHD (Vizio, D50u-D1, Wireless)"]) {
        //print(ua);
        expect(_Browser(ua).linux, isTrue);
      }

      for (final ua in [
"Mozilla/5.0 CK={} (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1",
"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36",
"Opera/9.80 (Windows Mobile; Opera Mini/5.1.21594/28.1977; U; en) Presto/2.8.119 Version/11.10"]) {
        //print(ua);
        expect(_Browser(ua).windows, isTrue);
      }
    });
  });
}

const newEdge =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
  "Chrome/83.0.4103.116 Safari/537.36 Edg/83.0.478.45";

class _Browser extends Browser {
  @override
  final String userAgent;

  _Browser(this.userAgent);
}
