//Copyright (C) 2024 Potix Corporation. All Rights Reserved.
//History: Sun May 12 20:17:26 CST 2024
// Author: tomyeh
part of rikulo_util;

/// Replaces the occurrence of the keys of [replaces] in [text]
/// with the corresponding value of [replaces].
/// 
///     final _escape = ReplaceAll(const {"\\": r"\\", "\n": r"\n"});
///     _escape.apply(text);
class ReplaceAll {
  RegExp _pattern;
  final Map<String, String> _replaces;

  ReplaceAll(Map<String, String> replaces)
  : _pattern = _toPattern(replaces.keys), _replaces = replaces;

  /** Applies the replacement to the given [text].
   */
  String apply(String text)
  => text.replaceAllMapped(_pattern, _map);

  /** Maps the given match ([m]) to a replacement.
   * 
   * Default: it uses the replaces map given in the constructor.
   */
  String _map(Match m) => _replaces[m.group(0)]!;

  static RegExp _toPattern(Iterable<String> keys) {
    final buf = StringBuffer()..write('[');
    for (final String key in keys) {
      switch (key) {
        case '\r':
          buf.write(r"\r");
          continue;
        case '\n':
          buf.write(r"\n");
          continue;
        case '\t':
          buf.write(r"\t");
          continue;

        case '\\':
        case ']':
        case '-':
          buf.write("\\");
      }
      buf.write(key);
    }
    buf.write(']');
    return RegExp(buf.toString());
  }
}
