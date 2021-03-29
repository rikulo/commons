//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:29:00 PM
// Author: tomyeh
part of rikulo_io;

/// The cookie's name for holding Dart session ID.
const String dartSessionId = "DARTSESSID";

/// Sends an Ajax request to the given [url].
/// It returns the data received, or null if error.
/// 
/// To send data in `List<int>, pass it via [data].
/// To send in String, pass it via [body].
/// 
/// * [onResponse] used to retrieve the status code
/// and/or the response's headers.
/// Ignored if not specified.
/// It can return false to indicate the request fails. Then [ajax]
/// will return null.
/// If not specified or it returns true, it continues if
/// [isHttpStatusOK] is true.
Future<List<int>?> ajax(Uri url, {String method: "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?}) async {
  final client = new HttpClient();
  try {
    final xhr = await client.openUrl(method, url);
    if (headers != null) {
      final xhrheaders = xhr.headers;
      headers.forEach(xhrheaders.add);
    }

    if (data != null) xhr.add(data);
    if (body != null) xhr.write(body);

    final resp = await xhr.close(),
      statusCode = resp.statusCode;

    if (!(onResponse?.call(resp) ?? isHttpStatusOK(statusCode))) {
      resp.listen(_ignore).asFuture().catchError(_voidCatch);
        //need to pull out response.body. Or, it will never ends (memory leak)
      return null;
    }

    final result = <int>[];
    await resp.listen(result.addAll).asFuture();
    return result;
  } finally {
    try {
      client.close();
    } catch (_) {
    }
  }
}
void _ignore(List<int> data) {}
void _voidCatch(ex) {}

/// Sends an Ajax request to the given [url] using the POST method.
Future<List<int>?> postAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?})
=> ajax(url, method: "POST", data: data, body: body,
    headers: headers, onResponse: onResponse);

/// Sends an Ajax request to the given [url] using the PUT method.
Future<List<int>?> putAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?})
=> ajax(url, method: "PUT", data: data, body: body,
    headers: headers, onResponse: onResponse);

/// Sends an Ajax request to the given [url] using the DELETE method.
Future<List<int>?> deleteAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?})
=> ajax(url, method: "DELETE", data: data, body: body,
    headers: headers, onResponse: onResponse);

/// Sends an Ajax request to the given [url] using the HEAD method.
Future<List<int>?> headAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?})
=> ajax(url, method: "HEAD", data: data, body: body,
    headers: headers, onResponse: onResponse);

/// Sends an Ajax request to the given [url] using the PATCH method.
Future<List<int>?> patchAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool onResponse(HttpClientResponse response)?})
=> ajax(url, method: "PATCH", data: data, body: body,
    headers: headers, onResponse: onResponse);

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
      Stream<List<int>> request, [Map<String, String>? parameters]) async
  => decodeQuery(await readAsString(request), parameters);

  /** Decodes the query string into a map of name-value pairs (aka., parameters).
   *
   * * [queryString] - the query string shall not contain `'?'`.
   * * [parameters] - the map to put the decoded parameters into.
   * If null, this method will instantiate a new map.
   */
  static Map<String, String> decodeQuery(
      String queryString, [Map<String, String>? parameters]) {
    if (parameters == null)
      parameters = <String, String>{};

    int i = 0, len = queryString.length;
    while (i < len) {
      int j = i;
      int? iEquals;
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
      final value = parameters[name],
        sval = value != null ? value.toString(): null;
      if (sval?.isNotEmpty ?? false)
        buf.write(Uri.encodeQueryComponent(sval!));
    }
    return buf.toString();
  }
}
