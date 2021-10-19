//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Jan 08, 2013  6:46:38 PM
// Author: tomyeh
part of rikulo_io;

/// The HTTP request wrapper.
class HttpRequestWrapper implements HttpRequest {
  /// Constructor.
  /// 
  /// - [origin]: the original request.
  /// Note: it can be null. However, if null, you can't call
  /// most of methods, including [origin].
  /// It is design to make it easier to implement a *dummy* request.
  HttpRequestWrapper(HttpRequest? origin): _origin = origin;

  /// The origin stream
  ///
  /// Note: if you pass null to the constructor, calling this method
  /// will throw NPE
  HttpRequest get origin => _origin!;
  HttpRequest? _origin;

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
  X509Certificate? get certificate => origin.certificate;
  @override
  HttpSession get session => origin.session;
  @override
  HttpResponse get response => origin.response;
  @override
  String get protocolVersion => origin.protocolVersion;
  @override
  HttpConnectionInfo? get connectionInfo => origin.connectionInfo;

  @override
  String toString() => origin.toString();

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => origin.listen(onData,
      onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Future<bool> any(bool Function(Uint8List element) test)
  => origin.any(test);

  @override
  Stream<Uint8List> asBroadcastStream({
    void Function(StreamSubscription<Uint8List> subscription)? onListen,
    void Function(StreamSubscription<Uint8List> subscription)? onCancel,
  }) => origin.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(Uint8List event) convert)
  => origin.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(Uint8List event) convert)
  => origin.asyncMap(convert);

  @override
  Stream<R> cast<R>() => origin.cast<R>();

  @override
  Future<bool> contains(Object? needle) => origin.contains(needle);

  @override
  Stream<Uint8List> distinct([bool Function(Uint8List previous, Uint8List next)? equals])
  => origin.distinct(equals);

  @override
  Future<E> drain<E>([E? futureValue]) => origin.drain<E>(futureValue);

  @override
  Future<Uint8List> elementAt(int index) => origin.elementAt(index);

  @override
  Future<bool> every(bool Function(Uint8List element) test)
  => origin.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> Function(Uint8List element) convert)
  => origin.expand(convert);

  @override
  Future<Uint8List> get first => origin.first;

  @override
  Future<Uint8List> firstWhere(
    bool Function(Uint8List element) test, {
    Uint8List Function()? orElse,
  }) => origin.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
      S initialValue, S Function(S previous, Uint8List element) combine)
  => origin.fold(initialValue, combine);

  @override
  Future<dynamic> forEach(void Function(Uint8List element) action)
  => origin.forEach(action);

  @override
  Stream<Uint8List> handleError(
    Function onError, {
    bool Function(dynamic error)? test,
  }) => origin.handleError(onError, test: test);

  @override
  bool get isBroadcast => origin.isBroadcast;

  @override
  Future<bool> get isEmpty => origin.isEmpty;

  @override
  Future<String> join([String separator = '']) => origin.join(separator);

  @override
  Future<Uint8List> get last => origin.last;

  @override
  Future<Uint8List> lastWhere(
    bool Function(Uint8List element) test, {
    Uint8List Function()? orElse,
  }) => origin.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => origin.length;

  @override
  Stream<S> map<S>(S Function(Uint8List event) convert)
  => origin.map(convert);

  @override
  Future<dynamic> pipe(StreamConsumer<Uint8List> streamConsumer)
  => origin.pipe(streamConsumer);

  @override
  Future<Uint8List> reduce(
      Uint8List Function(Uint8List previous, Uint8List element) combine)
  => origin.reduce(combine);

  @override
  Future<Uint8List> get single => origin.single;

  @override
  Future<Uint8List> singleWhere(
    bool Function(Uint8List element) test, {
    Uint8List Function()? orElse,
  }) => origin.singleWhere(test, orElse: orElse);

  @override
  Stream<Uint8List> skip(int count) => origin.skip(count);

  @override
  Stream<Uint8List> skipWhile(bool Function(Uint8List element) test)
  => origin.skipWhile(test);

  @override
  Stream<Uint8List> take(int count) => origin.take(count);

  @override
  Stream<Uint8List> takeWhile(bool Function(Uint8List element) test)
  => origin.takeWhile(test);

  @override
  Stream<Uint8List> timeout(
    Duration timeLimit, {
    void Function(EventSink<Uint8List> sink)? onTimeout,
  }) => origin.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<List<Uint8List>> toList() => origin.toList();

  @override
  Future<Set<Uint8List>> toSet() => origin.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<Uint8List, S> streamTransformer)
  => origin.transform(streamTransformer);

  @override
  Stream<Uint8List> where(bool Function(Uint8List event) test)
  => origin.where(test);
}

/// The HTTP response wrapper.
class HttpResponseWrapper extends IOSinkWrapper implements HttpResponse {
  /// Constructor.
  /// 
  /// - [origin]: the original response.
  /// Note: it can be null. However, if null, you can't call
  /// most of methods, including [origin].
  /// It is design to make it easier to implement a *dummy* response.
  HttpResponseWrapper(HttpResponse? origin): super(origin);

  @override
  HttpResponse get origin => super.origin as HttpResponse;

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
  Duration? get deadline => origin.deadline;
  @override
  void set deadline(Duration? deadline) {
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
  HttpConnectionInfo? get connectionInfo => origin.connectionInfo;
}

/** A skeletal implementation for buffered HTTP response,
 * that is, the output will be buffered.
 *
 * Notice that, unlike [HttpResponseWrapper], to override the output
 * target, you need to override only [add] and [write].
 */
abstract class AbstractBufferedResponse extends HttpResponseWrapper {
  AbstractBufferedResponse(HttpResponse? origin): super(origin);

  @override
  Future flush() => Future.value();
  @override
  Future close() {
    _closer.complete();
    return done;
  }
  @override
  Future get done => _closer.future;

  //Used for implementing [close] and [done]//
  Completer get _closer
  => _$closer ?? (_$closer = Completer());
  Completer? _$closer;

  @override
  Future addStream(Stream<List<int>> stream) {
    final completer = Completer();
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
  void writeln([Object? obj = ""]) {
    write(obj);
    write("\n");
  }
  @override
  void writeCharCode(int charCode) {
    write(String.fromCharCode(charCode));
  }
}

/** A buffered HTTP response that stores the output in the given string buffer
 * rather than the original `HttpResponse` instance.
 */
class StringBufferedResponse extends AbstractBufferedResponse {
  ///The buffer for holding the output (instead of [origin])
  final StringBuffer buffer;
  StringBufferedResponse(HttpResponse? origin, this.buffer): super(origin);

  @override
  void add(List<int> data) {
    buffer.write(encoding.decode(data));
  }
  @override
  void write(Object? obj) {
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
  BufferedResponse(HttpResponse? origin, this.buffer): super(origin);

  @override
  void add(List<int> data) {
    buffer.addAll(data);
  }
  @override
  void write(Object? obj) {
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
  /// Constructor.
  /// 
  /// - [origin]: the original header.
  /// Note: it can be null. However, if null, you can't call
  /// most of methods, including [origin].
  /// It is design to make it easier to implement a *dummy* header.
  HttpHeadersWrapper(HttpHeaders? origin): _origin = origin;

  /// The original HTTP headers
  ///
  /// Note: if you pass null to the constructor, calling this method
  /// will throw NPE
  HttpHeaders get origin => _origin!;
  HttpHeaders? _origin;

  @override
  List<String>? operator[](String name) => origin[name];
  @override
  String? value(String name) => origin.value(name);

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    origin.add(name, value, preserveHeaderCase: preserveHeaderCase);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    origin.set(name, value, preserveHeaderCase: preserveHeaderCase);
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
  DateTime? get date => origin.date;
  @override
  void set date(DateTime? date) {
    origin.date = date;
  }
  @override
  DateTime? get expires => origin.expires;
  @override
  void set expires(DateTime? expires) {
    origin.expires = expires;
  }
  @override
  DateTime? get ifModifiedSince => origin.ifModifiedSince;
  @override
  void set ifModifiedSince(DateTime? ifModifiedSince) {
    origin.ifModifiedSince = ifModifiedSince;
  }
  @override
  String? get host => origin.host;
  @override
  void set host(String? host) {
    origin.host = host;
  }
  @override
  int? get port => origin.port;
  @override
  void set port(int? port) {
    origin.port = port;
  }
  @override
  ContentType? get contentType => origin.contentType;
  @override
  void set contentType(ContentType? contentType) {
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
