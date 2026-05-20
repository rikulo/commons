//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:29:00 PM
// Author: tomyeh
part of rikulo_io;

/// The cookie's name for holding Dart session ID.
const String dartSessionId = "DARTSESSID";

/// Sends an Ajax request to the given [url].
/// Returns the data received, or `null` on error.
///
/// To send data in `List<int>`, pass it via [data].
/// To send in String, pass it via [body].
///
/// * [onResponse] used to retrieve the status code,
/// the response's headers, or force [ajax] to return the body.
/// Ignored if not specified.
///
/// Notice that, by default, [ajax] returns null if the status code
/// is not between 200 and 299 (see [isHttpStatusOK]). That is, by default,
/// [ajax] ignores the body if the status code indicates an error.
///
/// If the error description will be in the request's body, you have
/// to specify [onResponse] with a callback returning true.
/// On the other hand, if [onResponse] returns false, [ajax] will ignore
/// the body, and returns null.
/// If [onResponse] returns null, it is handled as default (as described
/// above).
///
/// * [timeout] bounds the entire request — connect, send, response,
/// and body read. If exceeded, the underlying [HttpClient] is force-closed
/// (releasing the socket immediately) and [TimeoutException] is thrown.
/// If null (default), there is no timeout.
Future<List<int>?> ajax(Uri url, {String method = "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout}) {
  assert(data == null || body == null,
      'pass either `data` or `body`, not both');
  final client = HttpClient();

  Future<List<int>?> doIt() async {
    try {
      final xhr = await client.openUrl(method, url);
      //Use `set` (not `add`) so caller-supplied headers replace Dart's
      //defaults, matching package:http's IOClient.send.
      headers?.forEach(xhr.headers.set);

      //Send fixed-length (matches package:http) instead of
      //`Transfer-Encoding: chunked`, which some endpoints (e.g. S3 PUT
      //under SigV2) reject. Length is always known: 0 when no body.
      final List<int> bytes = data
          ?? (body != null ? utf8.encode(body): const <int>[]);
      xhr.contentLength = bytes.length;
      if (bytes.isNotEmpty) xhr.add(bytes);

      final resp = await xhr.close(),
        statusCode = resp.statusCode;

      if (!(onResponse?.call(resp) ?? isHttpStatusOK(statusCode))) {
        // Always discard the body so the connection can finish cleanly.
        await resp.drain();
        return null;
      }

      // Read the whole body.
      final result = BytesBuilder(copy: false);
      await for (final chunk in resp) {
        result.add(chunk);
      }
      return result.takeBytes();

    } finally {
      InvokeUtil.invokeSafely(client.close);
    }
  }

  final inner = doIt();
  if (timeout == null) return inner;

  return inner.timeout(timeout, onTimeout: () {
    //force-close so the in-flight socket is released immediately
    //(otherwise the connection would linger until the OS-level TCP timeout).
    client.close(force: true);
    //after force-close, `inner` will error out late — suppress it
    inner.ignore();
    throw TimeoutException('ajax($method $url)', timeout);
  });
}

/// Sends an Ajax request to the given [url] using the POST method.
Future<List<int>?> postAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout})
=> ajax(url, method: "POST", data: data, body: body,
    headers: headers, onResponse: onResponse, timeout: timeout);

/// Sends an Ajax request to the given [url] using the PUT method.
Future<List<int>?> putAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout})
=> ajax(url, method: "PUT", data: data, body: body,
    headers: headers, onResponse: onResponse, timeout: timeout);

/// Sends an Ajax request to the given [url] using the DELETE method.
Future<List<int>?> deleteAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout})
=> ajax(url, method: "DELETE", data: data, body: body,
    headers: headers, onResponse: onResponse, timeout: timeout);

/// Sends an Ajax request to the given [url] using the HEAD method.
Future<List<int>?> headAjax(Uri url, {
    Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout})
=> ajax(url, method: "HEAD",
    headers: headers, onResponse: onResponse, timeout: timeout);

/// Sends an Ajax request to the given [url] using the PATCH method.
Future<List<int>?> patchAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    bool? Function(HttpClientResponse response)? onResponse,
    Duration? timeout})
=> ajax(url, method: "PATCH", data: data, body: body,
    headers: headers, onResponse: onResponse, timeout: timeout);

/// HTTP related utilities
class HttpUtil {
  /// Decodes the parameters of the POST request.
  ///
  /// * [parameters] - the map to put the decoded parameters into.
  /// If null, this method will instantiate a new map.
  /// To merge the parameters found in the query string, you can do:
  ///
  ///     final params = HttpUtil.decodePostedParameters(
  ///       request, Map.from(request.queryParameters));
  /// + [maxLength] the maximal allowed length.
  /// If omitted, no limitation at all.
  /// If specified and the input is more than allowed, [PayloadException]
  /// will be thrown.
  static Future<Map<String, String>> decodePostedParameters(
      Stream<List<int>> request, {Map<String, String>? parameters,
      int? maxLength}) async
  => decodeQuery(await readAsString(request, maxLength: maxLength),
        parameters: parameters);

  /** Decodes the query string into a map of name-value pairs (aka., parameters).
   *
   * * [queryString] - the query string shall not contain `'?'`.
   * * [parameters] - the map to put the decoded parameters into.
   * If null, this method will instantiate a new map.
   */
  static Map<String, String> decodeQuery(
      String queryString, {Map<String, String>? parameters}) {
    parameters ??= <String, String>{};

    int i = 0, len = queryString.length;
    while (i < len) {
      int j = i;
      int? iEquals;
      for (; j < len; ++j) {
        final cc = queryString.codeUnitAt(j);
        if (cc == $equal)
          iEquals ??= j;
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
  /** Encodes the given parameters into a query string.
   * Notice the returned string won't start with `'?'`.
   *
   * The value of a parameter will be converted to a string first.
   * If it is null or its string form is empty, only `name=` is
   * emitted (no value).
   */
  static String encodeQuery(Map<String, dynamic> parameters) {
    final buf = StringBuffer();
    for (final entry in parameters.entries) {
      if (buf.isNotEmpty)
        buf.write('&');
      buf..write(Uri.encodeQueryComponent(entry.key))..write('=');
      final sval = entry.value?.toString();
      if (sval != null && sval.isNotEmpty)
        buf.write(Uri.encodeQueryComponent(sval));
    }
    return buf.toString();
  }
}
