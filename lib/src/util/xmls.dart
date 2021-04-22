//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Sep 11, 2012 12:00:59 PM
// Author: tomyeh
part of rikulo_util;

/**
 * XML Utilities.
 */
class XmlUtil {
  /** Encodes the string to a valid XML string.
   *
   * + [value] is the text to encode.
   * + [pre] - whether to replace whitespace with &nbsp;
   * + [space] - whether to keep the space but still able to break
   * lines. If [pre] is true, [space] is ignored.
   * + [multiLine] - whether to replace linefeed with <br/>
   * + [entity] - whether [value] might contain XML entities, such as `&#8214;`
   * and `&quot;`. If true, it won't encode it if an entity is found.
   * If true, you can escape with a backslash, such as `\&amp;`. So, it won't
   * be treated as a XML entity.
   * Note: backslash won't be handled specially if false.
   * Default: false.
   */
  static T encode<T extends String?>(T value,
      {bool multiLine: false, bool pre: false,
       bool space: false, bool entity: false}) {
    if (value == null) return null;

    final len = value.length;
    if (len == 0) return value; //as it is

    final buf = new StringBuffer();
    int i = 0, j = 0;
    void flush(String text, [int? end]) {
      buf..write(value.substring(j, end ?? i))
        ..write(text);
      j = i + 1;
    }

    for (bool escape = false; i < len; ++i) {
      final cc = value.codeUnitAt(i);
      if (entity) {
        if (escape) {
          escape = false;
          if (cc == $amp) {
            flush('&amp;', i - 1);
            continue;
          } else if (cc == $backslash) {
            flush('');
            continue;
          }
          //fall thru
        } else if (cc == $amp) {
          final m = _reXmlEntity.matchAsPrefix(value, i);
          if (m != null) i = m.end - 1; //put entity to output directly
          else flush('&amp;');
          continue;
        } else if (cc == $backslash) {
          escape = true;
          continue;
        }
        //fall thru
      }

      var replace = _encBasic[cc];
      if (replace == null) {
        if (multiLine) replace = _encLine[cc];

        if (replace == null && (pre || space)) {
          var count$ = _encSpace[cc];
          if (count$ != null) {
            var count = count$;
            late int k;
            if (!pre) { //pre has higher priority than space
            //convert consecutive whitespaces to &nbsp; plus a space
              for (k = i; ++k < len;) {
                final diff = _encSpace[value.codeUnitAt(k)];
                if (diff == null) break;
                count += diff;
              }
              if (--count == 0) //we'll add extra space if pre at the end
                continue; //if single space, no special handling (optimize)
            }

            flush('');

            while (--count >= 0)
              buf.write('&nbsp;');

            if (!pre) {
              buf.write(' '); //a space for line-break here
              i = (j = k) - 1;
            }
            continue;
          }
        }
      }

      if (replace != null) flush(replace);
    }

    if (buf.isEmpty) return value;
    flush('');
    return buf.toString();
  }

  static const _encBasic = const <int, String> {
    $lt: '&lt;', $gt: '&gt;', $amp: '&amp;', $quot: "&quot;",
  };
  static const _encLine = const <int, String> {
    $lf: '<br/>\n', $cr: '',
  };
  static const _encSpace = const <int, int> {
    $space: 1, $tab: 4,
  };

  static final _reXmlEntity =
      RegExp(r"&([a-z0-9]+|#[0-9]+|#[x][a-f0-9]+);", caseSensitive: false);
  static const _decs = <String, String> {
      'lt': '<', 'gt': '>', 'amp': '&', 'quot': '"', 'nbsp': ' '
  };

  static String _decMapper(Match m) {
    final key = m.group(1)!.toLowerCase();
    final mapped = _decs[key];
    if (mapped != null)
      return mapped;

    if (key.length >= 3 && key.codeUnitAt(0) == $hash) {
      final k1 = key.codeUnitAt(1);
      return String.fromCharCodes(
          [int.parse(k1 == $x || k1 == $X ?
              "0x${key.substring(2)}": key.substring(1))]);
    }

    return m.group(0)!;
  }

  /** Decodes the XML string into a normal string.
   * For example, `&lt;` is convert to `<`.
   *
   * + [txt] is the text to decode.
   */
  static T decode<T extends String?>(T value)
  => value == null ? null: value.replaceAllMapped(_reXmlEntity, _decMapper);
}
