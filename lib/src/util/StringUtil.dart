//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun Jan 15 11:04:13 TST 2012
// Author: tomyeh
part of rikulo_util;

/** String utilities.
 */
class StringUtil {
  /**
   * Returns whether the character matches the specified conditions.
   *
   * + [cc] is the character to test.
   * + [digit] specifies if it matches digit.
   * + [upper] specifies if it matches upper case.
   * + [lower] specifies if it matches lower case.
   * + [whitespace] specifies if it matches whitespace.
   * + [match] specifies a string of characters that are matched (aka., allowed).
   */
  static bool isChar(String cc, {bool digit: false, bool upper: false, bool lower: false,
  bool whitespace: false, String match: null}) {
    int v = cc.isEmpty ? 0: cc.codeUnitAt(0);
    return (digit && v >= _CC_0 && v <= _CC_9)
    || (upper && v >= _CC_A && v <= _CC_Z)
    || (lower && v >= _CC_a && v <= _CC_z)
    || (whitespace && _WHITE_SPACES.indexOf(cc) >= 0)
    || (match != null && match.indexOf(cc) >= 0);
  }

  /** Returns the index of the first non-whitespace character starting at [from],
   * `min(from, str.length)` if not found.
   */
  static int skipWhitespaces(String str, int from) {
    for (int len = str.length; from < len; ++from)
      if (!isChar(str[from], whitespace: true))
        break;
    return from;
  }

  /** Camelizes the given string.
   * For example, `background-color' => `backgroundColor`.
   *
   * Note: for better performance, it assumes there must be a character following a dash.
   */
  static String camelize(String name) {
    StringBuffer sb;
    int k = 0;
    for (int i = 0, len = name.length; i < len; ++i) {
      if (name[i] == '-') {
        if (sb == null) sb = new StringBuffer();
        sb..write(name.substring(k, i))
          ..write(name[++i].toUpperCase());
        k = i + 1;
      }
    }
    return sb != null ? (sb..write(name.substring(k))).toString(): name;
  }
  /** Uncamelizes the give string.
   * For example, `backgroundColor' => `background-color`.
   */
  static String uncamelize(String name) {
    StringBuffer sb;
    int k = 0;
    for (int i = 0, len = name.length; i < len; ++i) {
      final cc = name.codeUnitAt(i);
      if (cc >= _CC_A && cc <= _CC_Z) {
        if (sb == null) sb = new StringBuffer();
        sb..write(name.substring(k, i))..write('-')..write(name[i].toLowerCase());
        k = i + 1;
      }
    }
    return sb != null ? (sb..write(name.substring(k))).toString(): name;
  }
}

const int _CC_0 = 48, _CC_9 = _CC_0 + 9,
  _CC_A = 65, _CC_Z = _CC_A + 25,
  _CC_a = 97, _CC_z = _CC_a + 25;
const String _WHITE_SPACES = " \t\n\r\u{0085}\u{00a0}";
