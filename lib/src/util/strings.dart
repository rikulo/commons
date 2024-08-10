//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sun Jan 15 11:04:13 TST 2012
// Author: tomyeh
part of rikulo_util;

const _whitespacesA = const <int>[
    0x20, 0x85, 0xA0,
    0x1680, 0x2000, 0x2001, 0x2002, 0x2003, 0x2004, 0x2005, 0x2006,
    0x2007, 0x2008, 0x2009, 0x200A, 0x2028, 0x2029, 0x202F, 0x205F,
    0x3000, 0xFEFF];
/// A set of whitespaces in code units.
final $whitespaces = {..._whitespacesA,
    0x09, 0x0A, 0x0B, 0x0C, 0x0D}; //ref: Dart SDK: _isWhitespace

/// A regular expression to match a whitespace.
final regexWhitespaces = new RegExp(
    r'[\t\n\v\r\f' + new String.fromCharCodes(_whitespacesA) +']');

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
  static bool isChar(String cc, {bool digit = false, bool upper = false,
        bool lower = false, bool whitespace = false, String? match})
  => isCharCode(cc.codeUnitAt(0), digit: digit, upper: upper,
        lower: lower, whitespace: whitespace)
      || (match != null && match.contains(cc));

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
  static bool isCharCode(int cc, {bool digit = false, bool upper = false,
      bool lower = false, bool whitespace = false})
  =>   (lower && cc >= $a && cc <= $z)
    || (upper && cc >= $A && cc <= $Z)
    || (digit && cc >= $0 && cc <= $9)
    || (whitespace && $whitespaces.contains(cc));

  /** Returns the index of the first non-whitespace character starting at [from],
   * `min(from, str.length)` if not found.
   */
  static int skipWhitespaces(String str, int from) {
    for (int len = str.length; from < len; ++from)
      if (!$whitespaces.contains(str.codeUnitAt(from)))
        break;
    return from;
  }

  /** Camelizes the given string.
   * For example, `background-color' => `backgroundColor`.
   *
   * Note: for better performance, it assumes there must be a character following a dash.
   */
  static String camelize(String name) {
    StringBuffer? sb;
    int k = 0;
    for (int i = 0, len = name.length; i < len; ++i) {
      if (name.codeUnitAt(i) == $dash) {
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
    StringBuffer? sb;
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
