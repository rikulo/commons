//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Jan 08, 2013  6:46:38 PM
// Author: tomyeh
part of rikulo_io;

/**
 * The HTTP request wrapper.
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
  @override
  X509Certificate get certificate => origin.certificate;
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
 * The HTTP response wrapper.
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

/**
 * The HTTP headers wrapper.
 */
class HttpHeadersWrapper extends HttpHeaders {
  ///The original HTTP headers
  final HttpHeaders origin;

  HttpHeadersWrapper(HttpHeaders this.origin);

  //@override
  List<String> operator[](String name) => origin[name];
  //@override
  String value(String name) => origin.value(name);
  //@override
  void add(String name, Object value) {
    origin.add(name, value);
  }
  //@override
  void set(String name, Object value) {
    origin.set(name, value);
  }
  //@override
  void remove(String name, Object value) {
    origin.remove(name, value);
  }
  //@override
  void removeAll(String name) {
    origin.removeAll(name);
  }
  //@override
  void forEach(void f(String name, List<String> values)) {
    origin.forEach(f);
  }
  //@override
  void noFolding(String name) {
    origin.noFolding(name);
  }
  @override
  Date get date => origin.date;
  @override
  void set date(Date date) {
    origin.date = date;
  }
  @override
  Date get expires => origin.expires;
  @override
  void set expires(Date expires) {
    origin.expires = expires;
  }
  @override
  Date get ifModifiedSince => origin.ifModifiedSince;
  @override
  void set ifModifiedSince(Date ifModifiedSince) {
    origin.ifModifiedSince = ifModifiedSince;
  }
  @override
  String get host => origin.host;
  @override
  void set host(String host) {
    origin.host = host;
  }
  @override
  int get port => origin.port;
  @override
  void set port(int port) {
    origin.port = port;
  }
  @override
  ContentType get contentType => origin.contentType;
  @override
  void set contentType(ContentType contentType) {
    origin.contentType = contentType;
  }
} 