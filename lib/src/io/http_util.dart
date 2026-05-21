//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Apr 10, 2013  5:29:00 PM
// Author: tomyeh
part of rikulo_io;

/// The cookie's name for holding Dart session ID.
const String dartSessionId = "DARTSESSID";

/// Shortcut for `isHttpStatusOK(resp.statusCode)`.
bool isResponseOK(http.Response resp) => isHttpStatusOK(resp.statusCode);

/// Sends an Ajax request to the given [url] and returns the response.
///
/// Same semantics as `package:http`'s top-level functions (`http.get`,
/// `http.put`, …): body is buffered into the returned [http.Response].
/// Pass bytes via [data] or a string via [body].
///
/// * [timeout] bounds the entire request — connect, send, response,
/// and body read. If exceeded, the underlying [HttpClient] is
/// force-closed (releasing the socket immediately) and
/// [TimeoutException] is thrown. `package:http`'s top-level functions
/// cannot do this — they construct an internal `Client` and give no
/// handle to force-close.
Future<http.Response> ajax(Uri url, {String method = "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout})
=> _ajax(url, method: method, data: data, body: body, headers: headers,
    timeout: timeout, getResponse: http.Response.fromStream);

Future<http.Response> _ajax(Uri url, {String method = "GET",
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout,
    required Future<http.Response> Function(http.StreamedResponse resp)
        getResponse}) {
  assert(data == null || body == null,
      'pass either `data` or `body`, not both');

  //Own the HttpClient so we can force-close on timeout (releasing the
  //in-flight socket immediately). IOClient.close() only does a graceful
  //close, which is why package:http alone can't provide hard timeouts.
  final httpClient = HttpClient();
  final client = http_io.IOClient(httpClient);

  Future<http.Response> doIt() async {
    try {
      final request = http.Request(method, url);
      //Apply headers before setting body so that `request.body = ...`
      //picks up any caller-supplied Content-Type charset for encoding.
      headers?.forEach((k, v) => request.headers[k] = v);
      if (data != null) request.bodyBytes = data;
      else if (body != null) request.body = body;

      return await getResponse(await client.send(request));
    } finally {
      InvokeUtil.invokeSafely(client.close);
    }
  }

  final inner = doIt();
  if (timeout == null) return inner;

  return inner.timeout(timeout, onTimeout: () {
    httpClient.close(force: true);
    inner.ignore();
    throw TimeoutException('ajax($method $url)', timeout);
  });
}

/// Sends an Ajax request to the given [url] using the POST method.
Future<http.Response> postAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout})
=> ajax(url, method: "POST", data: data, body: body,
    headers: headers, timeout: timeout);

/// Sends an Ajax request to the given [url] using the PUT method.
Future<http.Response> putAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout})
=> ajax(url, method: "PUT", data: data, body: body,
    headers: headers, timeout: timeout);

/// Sends an Ajax request to the given [url] using the DELETE method.
Future<http.Response> deleteAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout})
=> ajax(url, method: "DELETE", data: data, body: body,
    headers: headers, timeout: timeout);

/// Sends an Ajax request to the given [url] using the PATCH method.
Future<http.Response> patchAjax(Uri url, {
    List<int>? data, String? body, Map<String, String>? headers,
    Duration? timeout})
=> ajax(url, method: "PATCH", data: data, body: body,
    headers: headers, timeout: timeout);

/// Sends an Ajax request to the given [url] using the HEAD method.
///
/// Unlike [ajax], the returned [http.Response.contentLength] reflects
/// the wire's `Content-Length` header — `http.Response.fromStream`
/// would otherwise report `0` for HEAD (the body is empty by
/// definition).
Future<http.Response> headAjax(Uri url, {
    Map<String, String>? headers,
    Duration? timeout})
=> _ajax(url, method: "HEAD", headers: headers, timeout: timeout,
    getResponse: _headResponse);

Future<http.Response> _headResponse(http.StreamedResponse resp) async {
  await resp.stream.drain();
  return _WireLengthResponse(const [], resp.statusCode,
      wireContentLength: resp.contentLength,
      request: resp.request,
      headers: resp.headers,
      isRedirect: resp.isRedirect,
      persistentConnection: resp.persistentConnection,
      reasonPhrase: resp.reasonPhrase);
}

class _WireLengthResponse extends http.Response {
  final int? _wireContentLength;
  _WireLengthResponse(super.bodyBytes, super.statusCode, {
    required int? wireContentLength,
    super.request, super.headers, super.isRedirect,
    super.persistentConnection, super.reasonPhrase,
  }) : _wireContentLength = wireContentLength,
       super.bytes();
  @override
  int? get contentLength => _wireContentLength;
}

/// Sends a request with a streamed body and returns the response.
///
/// The streaming counterpart to [ajax]: instead of buffering the
/// request body up front, the caller writes bytes into the
/// [EventSink] passed to [send] (e.g. by piping an inbound HTTP
/// request stream via `package:stream`'s `copyToSink`). The sink is
/// closed automatically when [send] returns or throws.
///
/// HEAD is not supported — use [headAjax] instead. This function
/// materializes the response via [http.Response.fromStream], which
/// would lose the wire's `Content-Length` for HEAD (the body is empty
/// by definition); [headAjax] handles this case correctly.
///
/// * [contentLength] — when known up front, set it so the outbound
/// request is sent fixed-length. If omitted, the request is sent
/// `Transfer-Encoding: chunked` (some endpoints, e.g. S3 PUT under
/// SigV2, reject chunked bodies).
///
/// * [timeout] — bounds the entire request. If exceeded, the underlying
/// [HttpClient] is force-closed and [TimeoutException] is thrown.
Future<http.Response> streamedAjax(Uri url,
    Future Function(EventSink<List<int>> sink) send,
    {String method = "GET", Map<String, String>? headers,
     int? contentLength, Duration? timeout}) {
  if (method.toUpperCase() == "HEAD")
    throw ArgumentError('HEAD: use headAjax');

  final httpClient = HttpClient();
  final client = http_io.IOClient(httpClient);

  Future<http.Response> doIt() async {
    try {
      final request = http.StreamedRequest(method, url);
      headers?.forEach((k, v) {
        //Promote `Content-Length` to `.contentLength`; left in the map
        //alone the request goes out as chunked.
        if (k.toLowerCase() == 'content-length') {
          assert(int.tryParse(v) != null, 'Content-Length: $v');
          request.contentLength ??= int.tryParse(v);
        } else {
          request.headers[k] = v;
        }
      });
      if (contentLength != null) request.contentLength = contentLength;

      //Drive the body before awaiting the response: `client.send` only
      //resolves after the body stream emits done.
      final responseFuture = client.send(request);
      responseFuture.ignore();
      try {
        await send(request.sink);
      } finally {
        request.sink.close();
      }
      return await http.Response.fromStream(await responseFuture);
    } finally {
      InvokeUtil.invokeSafely(client.close);
    }
  }

  final inner = doIt();
  if (timeout == null) return inner;

  return inner.timeout(timeout, onTimeout: () {
    httpClient.close(force: true);
    inner.ignore();
    throw TimeoutException('streamedAjax($method $url)', timeout);
  });
}

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
