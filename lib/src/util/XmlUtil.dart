//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Sep 11, 2012 12:00:59 PM
// Author: tomyeh
part of rikulo_util;

/**
 * XML Utilities.
 */
class XmlUtil {
  static final RegExp
    _reEncode0 = new RegExp(r"[<>&]"),
    _reEncode1 = new RegExp(r"[<>& \t]"),
    _reEncode2 = new RegExp(r"[<>&\r\n]"),
    _reEncode3 = new RegExp(r"[<>& \t\r\n]");
  static const Map<String, String> _encs =
    const {'<': '&lt;', '>': '&gt;', '&': '&amp;',
      '\n': '<br/>\n', '\r': '',
      ' ' : "&nbsp;", '\t': '&nbsp;&nbsp;&nbsp;&nbsp;'};

  static String _encMapper(Match m) => _encs[m.group(0)];

  /** Encodes the string to a valid XML string.
   *
   * + [txt] is the text to encode.
   * + [pre] - whether to replace whitespace with &nbsp;
   * + [multiLine] - whether to replace linefeed with <br/>
   */
  static String encode(String txt,
  {bool multiLine: false, bool pre: false}) {
    if (txt == null) return null; //as it is

    return txt.replaceAllMapped(
      multiLine ? pre ? _reEncode3: _reEncode2:
        pre ? _reEncode1: _reEncode0, _encMapper);
  }

  static final RegExp _reDecode = new RegExp(r"&([0-9a-z]*);");
  static const Map<String, String>
    _decs = const {'lt': '<', 'gt': '>', 'amp': '&'};

  static String _decMapper(Match m) {
    final String key = m.group(1);
    final String mapped = _decs[key];
    if (mapped != null)
      return mapped;

    if (key.length >= 3 && key[0] == '#')
      return new String.fromCharCodes(
          [int.parse(
            key[1].toLowerCase() == 'x' ?
              "0x${key.substring(2)}": key.substring(1))]);

    return m.group(0);
  }

  /** Decodes the XML string into a normal string.
   * For example, `&lt;` is convert to `<`.
   *
   * + [txt] is the text to decode.
   */
  static String decode(String txt) {
    if (txt == null) return null; //as it is

    return txt.replaceAllMapped(_reDecode, _decMapper);
  }
}
