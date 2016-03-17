//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 12, 2012  9:26:04 AM
// Author: tomyeh
library rikulo_browser;

/**
 * The browser.
 */
abstract class Browser {
  // all RegExp shall be lower case here
  static final RegExp _rwebkit = new RegExp(r"(webkit)[ /]([\w.]+)"),
    _rsafari = new RegExp(r"(safari)[ /]([\w.]+)"),
    _rchrome = new RegExp(r"(chrome|crios)[ /]([\w.]+)"),
    _redge = new RegExp(r"(edge)/([\w.]+)"),
    _rmsie = new RegExp(r"(msie) ([\w.]+)"),
    _rfirefox = new RegExp(r"(firefox)/([\w.]+)"),
    _ropera = new RegExp(r"(opera)(?:.*version)?[ /]([\w.]+)"),
    _riOS = new RegExp(r"os[ /]([\w_]+) like mac os"),
    _rmacOS = new RegExp(r"mac os "),
    _randroid = new RegExp(r"android[ /]([\w.]+)"),
    _rdart = new RegExp(r"[^a-z]dart[^a-z]");

  /** The browser's name. */
  String name;
  /** The browser's version. */
  double version;

  /** Whether it is Safari. */
  bool safari = false;
  /** Whether it is Chrome. */
  bool chrome = false;
  /** Whether it is Edge. */
  bool edge = false;
  /** Whether it is Internet Explorer. */
  bool ie = false;
  /** Whether it is Firefox. */
  bool firefox = false;
  /** Whether it is WebKit-based. */
  bool webkit = false;
  /** Whether it is Opera. */
  bool opera = false;

  /** Whether it is running on iOS. */
  bool iOS = false;
  /** Whether it is running on Android. */
  bool android = false;
  /** Whether it is running on MacOS. */
  bool macOS = false;

  /** Whehter it is running on a mobile device.
   * By mobile we mean the browser takes the full screen and non-sizable.
   * If false, the browser is assumed to run on a desktop and
   * it can be resized by the user.
   */
  bool mobile = false;

  /** Whether Dart is supported.
   */
  bool dart = false;

  /** The webkit's version if this is a webkit-based browser, or null
   * if it is not webkit-based. Note: Safari, Chrome and Edge are all
   * Webkit-based.
   */
  double webkitVersion;
  /** The browser's version.
   */
  double browserVersion;
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
      macOS = _rmacOS.hasMatch(ua);
    }
    
    if (bm(_rwebkit)) {
      webkit = true;
      webkitVersion = version;

      if (bm(_redge)) {
        edge = true;
        browserVersion = version;
      } else if (bm(_rchrome)) { //after edge
        chrome = true;
        browserVersion = version;
      } else if (bm(_rsafari)) { //after chrome
        safari = true;
        browserVersion = version;
      }
    } else if (bm(_rmsie) || ua.indexOf('trident') >= 0) {
      ie = true;
      browserVersion = version ?? 11.0;
      mobile = ua.indexOf("iemobile") >= 0;
    } else if (bm(_ropera)) {
      opera = true;
      browserVersion = version;
    } else if (bm(_rfirefox)) { //after opera
      firefox = true;
      browserVersion = version;
    } else {
      name = "";
      version = 1.0;
    }

    dart = _rdart.hasMatch(ua);
  }

  /** Parses the given [version] into a double.
   */
  static double parseVersion(String version, [String separator='.']) {
    try {
      int j = version.indexOf(separator);
      if (j >= 0) {
        j = version.indexOf(separator, j + 1);
        if (j >= 0)
          version = version.substring(0, j);
        if (separator != '.')
          version = version.replaceAll(separator, '.');
      }
      return double.parse(version);
    } catch (e) {
      return 1.0; //ignore it
    }
  }
}
