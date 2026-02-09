//Copyright (C) 2026 Potix Corporation. All Rights Reserved.
//History: Mon Feb  9 15:06:04 CST 2026
// Author: tomyeh
library rikulo_util.string;

import "../../util.dart" as util;

/// String utilities.
@deprecated
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
  static final isChar = util.isChar;

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
  static final isCharCode = util.isCharCode;

  /** Returns the index of the first non-whitespace character starting at [from],
   * `min(from, str.length)` if not found.
   */
  static final skipWhitespaces = util.skipWhitespaces;

  /** Camelizes the given string.
   * For example, `background-color' => `backgroundColor`.
   *
   * Note: for better performance, it assumes there must be a character following a dash.
   */
  static final camelize = util.camelize;

  /** Uncamelizes the give string.
   * For example, `backgroundColor' => `background-color`.
   */
  static final uncamelize = util.uncamelize;
}
