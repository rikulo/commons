//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:29:00 PM
// Author: tomyeh
part of rikulo_io;

/**
 * HTTP related utilities
 */
class HttpUtil {
  /** Decodes the query string into a map of name-value pairs (aka., parameters).
   *
   * [queryString] - the query string shall not contain `'?'`.
   */
  static Map<String, String> decodeQuery(String queryString) {
    Map<String, String> result = new LinkedHashMap<String, String>();
    int i = 0;
    while (i < queryString.length) {
      int j = queryString.indexOf("=", i);
      if (j == -1)
        break;

      String name = queryString.substring(i, j);
      i = j + 1;
      j = queryString.indexOf("&", i);
      String value;
      if (j == -1) {
        value = queryString.substring(i);
        i = queryString.length;
      } else {
        value = queryString.substring(i, j);
        i = j + 1;
      }
      result[decodeUriComponent(name)] = decodeUriComponent(value);
    }
    return result;
  }
  /** Encodes the given paramters into a query string.
   * Notice the returned string won't start with `'?'`.
   *
   * The value of a parameter will be converted to a string first.
   * If it is null, an empty string is generated.
   */
  static String encodeQuery(Map<String, dynamic> parameters) {
    final buf = new StringBuffer();
    for (final name in parameters.keys) {
      if (!buf.isEmpty)
        buf.write('&');
      buf..write(encodeUriComponent(name))..write('=');
      var value = parameters[name];
      if (value != null)
        value = value.toString();
      if (value != null && !value.isEmpty)
        buf.write(encodeUriComponent(value));
    }
    return buf.toString();
  }
}
