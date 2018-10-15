//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:29:00 PM
// Author: tomyeh
part of rikulo_io;

/**
 * HTTP related utilities
 */
class HttpUtil {
  /** Decodes the parameters of the POST request.
   *
   * * [parameters] - the map to put the decoded parameters into.
   * If null, this method will instantiate a new map.
   * To merge the parameters found in the query string, you can do:
   *
   *     final params = HttpUtil.decodePostedParameters(
   *       request, new Map.from(request.queryParameters));
   */
  static Future<Map<String, String>> decodePostedParameters(
      Stream<List<int>> request, [Map<String, String> parameters]) async
  => decodeQuery(await readAsString(request), parameters);

  /** Decodes the query string into a map of name-value pairs (aka., parameters).
   *
   * * [queryString] - the query string shall not contain `'?'`.
   * * [parameters] - the map to put the decoded parameters into.
   * If null, this method will instantiate a new map.
   */
  static Map<String, String> decodeQuery(
      String queryString, [Map<String, String> parameters]) {
    if (parameters == null)
      parameters = <String, String>{};

    int i = 0, len = queryString.length;
    while (i < len) {
      int j = i, iEquals;
      for (; j < len; ++j) {
        final cc = queryString.codeUnitAt(j);
        if (cc == $equal)
          iEquals = j;
        else if (cc == $amp || cc == $semicolon)
          break;
      }

      String name, value;
      if (iEquals != null) {
        name = queryString.substring(i, iEquals);
        value = queryString.substring(iEquals + 1, j);
      } else {
        name = queryString.substring(i, j);
        value = "";
      }
      i = j + 1;
      parameters[Uri.decodeQueryComponent(name)] = Uri.decodeQueryComponent(value);
    }
    return parameters;
  }
  /** Encodes the given paramters into a query string.
   * Notice the returned string won't start with `'?'`.
   *
   * The value of a parameter will be converted to a string first.
   * If it is null, an empty string is generated.
   */
  static String encodeQuery(Map<String, dynamic> parameters) {
    final buf = StringBuffer();
    for (final name in parameters.keys) {
      if (!buf.isEmpty)
        buf.write('&');
      buf..write(Uri.encodeQueryComponent(name))..write('=');
      final value = parameters[name];
      final String sval = value != null ? value.toString(): null;
      if (sval?.isNotEmpty == true)
        buf.write(Uri.encodeQueryComponent(sval));
    }
    return buf.toString();
  }
}
