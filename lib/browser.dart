//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh
library rikulo_browser;

/**
 * The browser.
 */
abstract class Browser {
  // all RegExp shall be lower case here
  static final _rwebkit = RegExp(r"(webkit)[ /]?([0-9]+[0-9.]*)"),
    _rsafari = RegExp(r"(version)/([\w.]+).*safari"),
    _rchrome = RegExp(r"(chrome|crios)[ /]([\w.]+)"),
    _redge = RegExp(r"(edge)/([\w.]+)"),
    _rie = RegExp(r"(msie) ([\w.]+)"),
    _rie2 = RegExp(r"trident/.+(rv:)([\w.]+)"),
    _rfirefox = RegExp(r"(firefox)/([\w.]+)"),
    _ropera = RegExp(r"(opera)(?:.*version)?[ /]([\w.]+)"),
    _riOS = RegExp(r"os[ /]([\w_]+) like mac os"),
    _randroid = RegExp(r"android[ /]([\w.]+)");

  /// The browser's name.
  String name;
  /** The browser's version.
   * 
   * Note: if the subversion is a single digit, it will be considered
   * as one hundredth (not tenth).
   * For example, version *12.1* will be parsed to a value as `12.01`
   * (not `12.1`). Thus, [version] of *12.10* is larger than that of *12.2*
   * as expected.
   */
  double version;

  /// Whether it is Safari.
  bool safari = false;
  /// Whether it is Chrome.
  bool chrome = false;
  /// Whether it is Edge.
  bool edge = false;
  /// Whether it is Internet Explorer.
  bool ie = false;
  /// Whether it is Firefox.
  bool firefox = false;
  /// Whether it is WebKit-based.
  bool webkit = false;
  /// Whether it is Opera.
  bool opera = false;

  /// Whether it is running on iOS.
  bool iOS = false;
  /// Whether it is running on Android.
  bool android = false;
  /// Whether it is running on MacOS.
  bool macOS = false;
  /// Whether it is runnon on Linux
  bool linux = false;
  /// Whether it is runnon on Windows
  bool windows = false;

  /** Whehter it is running on a mobile device.
   * By mobile we mean the browser takes the full screen and non-sizable.
   * If false, the browser is assumed to run on a desktop and
   * it can be resized by the user.
   */
  bool mobile;

  /** The webkit's version if this is a webkit-based browser, or null
   * if it is not webkit-based. Note: Safari, Chrome and Edge are all
   * Webkit-based.
   */
  double webkitVersion;

  /** The version of iOS if it is running on iOS, or null if not.
   */
  double iOSVersion;
  /** The version of Android if it is running on Android, or null if not.
   */
  double androidVersion;

  Browser() {
    _initBrowserInfo();
  }

  ///Returns the user agent.
  String get userAgent;

  void _initBrowserInfo() {
    final String ua = userAgent.toLowerCase();
    bool bm(RegExp regex) {
      final m = regex.firstMatch(ua);
      if (m != null) {
        name = m.group(1);
        version = parseVersion(m.group(2));
        return true;
      }
      return false;
    }

    // os detection
    Match m2;
    if ((m2 = _randroid.firstMatch(ua)) != null) {
      mobile = android = true;
      androidVersion = parseVersion(m2.group(1));
    } else if ((m2 = _riOS.firstMatch(ua)) != null) {
      mobile = iOS = true;
      iOSVersion = parseVersion(m2.group(1), '_');
    } else {
      mobile = ua.contains("mobile");
      macOS = ua.contains("mac os");
      if (!macOS) {
        linux = ua.contains("linux");
        if (!linux) windows = ua.contains("windows");
      }
    }
    
    if (bm(_rwebkit)) {
      webkit = true;
      webkitVersion = version;

      if (bm(_redge)) {
        edge = true;
      } else if (bm(_rchrome)) { //after edge
        chrome = true;
      } else if (bm(_rsafari)) { //after chrome
        safari = true;
        name = "safari";
      }
      //opera, firefox for iOS all based on ApplieWebKit, but
      //we consider them as webkit (than firefox or opera)
    } else if (bm(_rie) || bm(_rie2)) {
      ie = true;
      name = "ie";
    } else if (bm(_ropera)) {
      opera = true;
    } else if (bm(_rfirefox)) { //after opera
      firefox = true;
    } else {
      name = "";
      version = 1.0;
    }
  }

  /** Parses the given [version] into a double.
   */
  static double parseVersion(String version, [String separator='.']) {
    try {
      int j = version.indexOf(separator);
      if (j >= 0) {
        final k = version.indexOf(separator, ++j);
        if (k >= 0)
          version = version.substring(0, k);
        if (version.length == j + 1) //only one decimal, e.g., 12.3
          version = version.substring(0, j) + "0" + version.substring(j);
        if (separator != '.')
          version = version.replaceAll(separator, '.');
      }
      return double.parse(version);
    } catch (e) {
      return 1.0; //ignore it
    }
  }
}
