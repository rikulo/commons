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
  static bool isChar(String cc, {bool digit: false, bool upper: false,
        bool lower: false, bool whitespace: false, String match})
  => isCharCode(cc.codeUnitAt(0), digit: digit, upper: upper,
        lower: lower, whitespace: whitespace)
      || (match != null && match.indexOf(cc) >= 0);

  /**
   * Returns whether the character code matches the specified conditions.
   *
   * + [cc] is the character to test.
   * + [digit] specifies if it matches digit.
   * + [upper] specifies if it matches upper case.
   * + [lower] specifies if it matches lower case.
   * + [whitespace] specifies if it matches whitespace.
   * + [match] specifies a string of characters that are matched (aka., allowed).
   */
  static bool isCharCode(int cc, {bool digit: false, bool upper: false,
      bool lower: false, bool whitespace: false})
  =>   (digit && cc >= $0 && cc <= $9)
    || (upper && cc >= $A && cc <= $Z)
    || (lower && cc >= $a && cc <= $z)
    || (whitespace && whitespaces.contains(cc));

  static final whitespaces = const <int>[$space, $tab, $lf, $cr, $ff, 0x85, 0xa0].toSet();

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
        if (sb == null) sb = StringBuffer();
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
      if (cc >= $A && cc <= $Z) {
        if (sb == null) sb = StringBuffer();
        sb..write(name.substring(k, i))..write('-')..write(name[i].toLowerCase());
        k = i + 1;
      }
    }
    return sb != null ? (sb..write(name.substring(k))).toString(): name;
  }
}
