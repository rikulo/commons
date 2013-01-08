//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Jan 08, 2013  6:46:38 PM
// Author: tomyeh
part of rikulo_io;

/**
 * The request wrapper.
 */
class HttpRequestWrapper implements HttpRequest {
  ///The original HTTP request
  final HttpRequest origin;

  HttpRequestWrapper(HttpRequest this.origin);

  @override
  int get contentLength => origin.contentLength;
  @override
  bool get persistentConnection => origin.persistentConnection;
  @override
  String get method => origin.method;
  @override
  String get uri => origin.uri;
  @override
  String get path => origin.path;
  @override
  String get queryString => origin.queryString;
  @override
  Map<String, String> get queryParameters => origin.queryParameters;
  @override
  HttpHeaders get headers => origin.headers;
  @override
  List<Cookie> get cookies => origin.cookies;
  //@override
  HttpSession session([init(HttpSession session)]) => origin.session(init);
  @override
  InputStream get inputStream => origin.inputStream;
  @override
  String get protocolVersion => origin.protocolVersion;
  @override
  HttpConnectionInfo get connectionInfo => origin.connectionInfo;

  String toString() => origin.toString();
}

/**
 * The response wrapper.
 */
class HttpResponseWrapper implements HttpResponse {
  ///The original HTTP response
  final HttpResponse origin;

  HttpResponseWrapper(HttpResponse this.origin);

  @override
  int get contentLength => origin.contentLength;
  @override
  void set contentLength(int contentLength) {
    origin.contentLength = contentLength;
  }

  @override
  int get statusCode => origin.statusCode;
  @override
  void set statusCode(int statusCode) {
    origin.statusCode = statusCode;
  }

  @override
  String get reasonPhrase => origin.reasonPhrase;
  @override
  void set reasonPhrase(String reasonPhrase) {
    origin.reasonPhrase = reasonPhrase;
  }

  @override
  bool get persistentConnection => origin.persistentConnection;
  @override
  void set persistentConnection(bool persistentConnection) {
    origin.persistentConnection = persistentConnection;
  }

  @override
  HttpHeaders get headers => origin.headers;
  @override
  List<Cookie> get cookies => origin.cookies;
  @override
  OutputStream get outputStream => origin.outputStream;
  //@override
  DetachedSocket detachSocket() => origin.detachSocket();
  @override
  HttpConnectionInfo get connectionInfo => origin.connectionInfo;
}
