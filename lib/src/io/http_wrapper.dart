//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Jan 08, 2013  6:46:38 PM
// Author: tomyeh
part of rikulo_io;

/**
 * The HTTP request wrapper.
 */
class HttpRequestWrapper extends StreamWrapper<List<int>> implements HttpRequest {
  HttpRequestWrapper(HttpRequest origin): super(origin);

  HttpRequest get origin => super.origin;

  @override
  int get contentLength => origin.contentLength;
  @override
  bool get persistentConnection => origin.persistentConnection;
  @override
  String get method => origin.method;
  @override
  Uri get uri => origin.uri;
  @override
  Uri get requestedUri => origin.requestedUri;
  @override
  HttpHeaders get headers => origin.headers;
  @override
  List<Cookie> get cookies => origin.cookies;
  @override
  X509Certificate get certificate => origin.certificate;
  @override
  HttpSession get session => origin.session;
  @override
  HttpResponse get response => origin.response;
  @override
  String get protocolVersion => origin.protocolVersion;
  @override
  HttpConnectionInfo get connectionInfo => origin.connectionInfo;

  String toString() => origin.toString();
}

/**
 * The HTTP response wrapper.
 */
class HttpResponseWrapper extends IOSinkWrapper implements HttpResponse {
  HttpResponseWrapper(HttpResponse origin): super(origin);

  HttpResponse get origin => super.origin;

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
  Duration get deadline => origin.deadline;
  @override
  void set deadline(Duration deadline) {
    origin.deadline = deadline;
  }

  @override
  HttpHeaders get headers => origin.headers;
  @override
  bool get bufferOutput => origin.bufferOutput;
  @override
  void set bufferOutput(bool bufferOutput) {
    origin.bufferOutput = bufferOutput;
  }
  @override
  List<Cookie> get cookies => origin.cookies;

  @override
  Future redirect(Uri location, {int status: HttpStatus.movedTemporarily})
  => origin.redirect(location, status: status);

  @override
  Future<Socket> detachSocket({bool writeHeaders: true})
  => origin.detachSocket(writeHeaders: writeHeaders);
  @override
  HttpConnectionInfo get connectionInfo => origin.connectionInfo;
}

/** A skeletal implementation for buffered HTTP response,
 * that is, the output will be buffered.
 *
 * Notice that, unlike [HttpResponseWrapper], to override the output
 * target, you need to override only [add] and [write].
 */
abstract class AbstractBufferedResponse extends HttpResponseWrapper {
  AbstractBufferedResponse(HttpResponse origin): super(origin);

  @override
  Future flush() => new Future.value();
  @override
  Future close() {
    _closer.complete();
    return done;
  }
  @override
  Future get done => _closer.future;

  //Used for implementing [close] and [done]//
  Completer get _closer
  => _$closer != null ? _$closer: (_$closer = new Completer());
  Completer _$closer;

  @override
  Future addStream(Stream<List<int>> stream) {
    final completer = new Completer();
    stream.listen(add)
      ..onDone(completer.complete)
      ..onError(completer.completeError);
    return completer.future;
  }
  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    Iterator iterator = objects.iterator;
    if (!iterator.moveNext()) return;
    if (separator.isEmpty) {
      do {
        write(iterator.current);
      } while (iterator.moveNext());
    } else {
      write(iterator.current);
      while (iterator.moveNext()) {
        write(separator);
        write(iterator.current);
      }
    }
  }
  @override
  void writeln([Object obj = ""]) {
    write(obj);
    write("\n");
  }
  @override
  void writeCharCode(int charCode) {
    write(new String.fromCharCode(charCode));
  }
}

/** A buffered HTTP response that stores the output in the given string buffer
 * rather than the original `HttpResponse` instance.
 */
class StringBufferedResponse extends AbstractBufferedResponse {
  ///The buffer for holding the output (instead of [origin])
  final StringBuffer buffer;
  StringBufferedResponse(HttpResponse origin, this.buffer): super(origin);

  @override
  void add(List<int> data) {
    buffer.write(encoding.decode(data));
  }
  @override
  void write(Object obj) {
    buffer.write(obj);
  }
}

/** A buffered HTTP response that stores the output in the given list of bytes
 * buffer rather than the original `HttpResponse` instance.
 */
class BufferedResponse extends AbstractBufferedResponse {
  ///The buffer for holding the output (instead of [origin]).
  ///It is a list of bytes.
  final List<int> buffer;
  BufferedResponse(HttpResponse origin, this.buffer): super(origin);

  @override
  void add(List<int> data) {
    buffer.addAll(data);
  }
  @override
  void write(Object obj) {
    if (obj is num) {
      buffer.add(obj.toInt());
    } else {
      final String str = obj is String ? obj: obj.toString();
      if (str.isNotEmpty)
        buffer.addAll(encoding.encode(str));
    }
  }
}

/**
 * The HTTP headers wrapper.
 */
class HttpHeadersWrapper implements HttpHeaders {
  ///The original HTTP headers
  final HttpHeaders origin;

  HttpHeadersWrapper(this.origin);

  @override
  List<String> operator[](String name) => origin[name];
  @override
  String value(String name) => origin.value(name);
  @override
  void add(String name, Object value) {
    origin.add(name, value);
  }
  @override
  void set(String name, Object value) {
    origin.set(name, value);
  }
  @override
  void remove(String name, Object value) {
    origin.remove(name, value);
  }
  @override
  void removeAll(String name) {
    origin.removeAll(name);
  }
  @override
  void forEach(void f(String name, List<String> values)) {
    origin.forEach(f);
  }
  @override
  void noFolding(String name) {
    origin.noFolding(name);
  }
  @override
  DateTime get date => origin.date;
  @override
  void set date(DateTime date) {
    origin.date = date;
  }
  @override
  DateTime get expires => origin.expires;
  @override
  void set expires(DateTime expires) {
    origin.expires = expires;
  }
  @override
  DateTime get ifModifiedSince => origin.ifModifiedSince;
  @override
  void set ifModifiedSince(DateTime ifModifiedSince) {
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
  @override
  void clear() {
    origin.clear();
  }
  @override
  bool get chunkedTransferEncoding => origin.chunkedTransferEncoding;
  @override
  void set chunkedTransferEncoding(bool value) {
    origin.chunkedTransferEncoding = value;
  }
  @override
  int get contentLength => origin.contentLength;
  @override
  void set contentLength(int contentLength) {
    origin.contentLength = contentLength;
  }
  @override
  bool get persistentConnection => origin.persistentConnection;
  @override
  void set persistentConnection(bool value) {
    origin.persistentConnection = value;
  }
}
