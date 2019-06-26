//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Jan 08, 2013  6:46:38 PM
// Author: tomyeh
part of rikulo_io;

/**
 * The HTTP request wrapper.
 */
class HttpRequestWrapper implements HttpRequest {
  HttpRequestWrapper(this.origin);

  /// The origin stream
  final HttpRequest origin;

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

  @override
  String toString() => origin.toString();

  @override
  StreamSubscription<Uint8List> listen(
    void Function(Uint8List event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    return origin.transform(const _ToUint8List()).listen(
      onData,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Future<bool> any(bool Function(Uint8List element) test) {
    return origin.transform(const _ToUint8List()).any(test);
  }

  @override
  Stream<Uint8List> asBroadcastStream({
    void Function(StreamSubscription<Uint8List> subscription) onListen,
    void Function(StreamSubscription<Uint8List> subscription) onCancel,
  }) {
    return origin
        .transform(const _ToUint8List())
        .asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(Uint8List event) convert) {
    return origin.transform(const _ToUint8List()).asyncExpand<E>(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(Uint8List event) convert) {
    return origin.transform(const _ToUint8List()).asyncMap<E>(convert);
  }

  @override
  Stream<R> cast<R>() {
    return origin.cast<R>();
  }

  @override
  Future<bool> contains(Object needle) {
    return origin.contains(needle);
  }

  @override
  Stream<Uint8List> distinct([bool Function(Uint8List previous, Uint8List next) equals]) {
    return origin.transform(const _ToUint8List()).distinct(equals);
  }

  @override
  Future<E> drain<E>([E futureValue]) {
    return origin.drain<E>(futureValue);
  }

  @override
  Future<Uint8List> elementAt(int index) {
    return origin.transform(const _ToUint8List()).elementAt(index);
  }

  @override
  Future<bool> every(bool Function(Uint8List element) test) {
    return origin.transform(const _ToUint8List()).every(test);
  }

  @override
  Stream<S> expand<S>(Iterable<S> Function(Uint8List element) convert) {
    return origin.transform(const _ToUint8List()).expand(convert);
  }

  @override
  Future<Uint8List> get first => origin.transform(const _ToUint8List()).first;

  @override
  Future<Uint8List> firstWhere(
    bool Function(Uint8List element) test, {
    List<int> Function() orElse,
  }) {
    return origin.transform(const _ToUint8List()).firstWhere(test, orElse: () {
      return Uint8List.fromList(orElse());
    });
  }

  @override
  Future<S> fold<S>(
      S initialValue, S Function(S previous, Uint8List element) combine) {
    return origin.transform(const _ToUint8List()).fold<S>(initialValue, combine);
  }

  @override
  Future<dynamic> forEach(void Function(Uint8List element) action) {
    return origin.transform(const _ToUint8List()).forEach(action);
  }

  @override
  Stream<Uint8List> handleError(
    Function onError, {
    bool Function(dynamic error) test,
  }) {
    return origin.transform(const _ToUint8List()).handleError(onError, test: test);
  }

  @override
  bool get isBroadcast => origin.isBroadcast;

  @override
  Future<bool> get isEmpty => origin.isEmpty;

  @override
  Future<String> join([String separator = '']) {
    return origin.join(separator);
  }

  @override
  Future<Uint8List> get last => origin.transform(const _ToUint8List()).last;

  @override
  Future<Uint8List> lastWhere(
    bool Function(Uint8List element) test, {
    List<int> Function() orElse,
  }) {
    return origin.transform(const _ToUint8List()).lastWhere(test, orElse: () {
      return Uint8List.fromList(orElse());
    });
  }

  @override
  Future<int> get length => origin.length;

  @override
  Stream<S> map<S>(S Function(Uint8List event) convert) {
    return origin.transform(const _ToUint8List()).map<S>(convert);
  }

  @override
  Future<dynamic> pipe(StreamConsumer<List<int>> streamConsumer) {
    return origin.pipe(streamConsumer);
  }

  @override
  Future<Uint8List> reduce(
      List<int> Function(Uint8List previous, Uint8List element) combine) {
    return origin.transform(const _ToUint8List()).reduce((p, e) => Uint8List.fromList(combine(p, e))
    );
  }

  @override
  Future<Uint8List> get single => origin.transform(const _ToUint8List()).single;

  @override
  Future<Uint8List> singleWhere(
    bool Function(Uint8List element) test, {
    List<int> Function() orElse,
  }) {
    return origin.transform(const _ToUint8List()).singleWhere(test, orElse: () {
      return Uint8List.fromList(orElse());
    });
  }

  @override
  Stream<Uint8List> skip(int count) {
    return origin.transform(const _ToUint8List()).skip(count);
  }

  @override
  Stream<Uint8List> skipWhile(bool Function(Uint8List element) test) {
    return origin.transform(const _ToUint8List()).skipWhile(test);
  }

  @override
  Stream<Uint8List> take(int count) {
    return origin.transform(const _ToUint8List()).take(count);
  }

  @override
  Stream<Uint8List> takeWhile(bool Function(Uint8List element) test) {
    return origin.transform(const _ToUint8List()).takeWhile(test);
  }

  @override
  Stream<Uint8List> timeout(
    Duration timeLimit, {
    void Function(EventSink<Uint8List> sink) onTimeout,
  }) {
    return origin.transform(const _ToUint8List()).timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<List<Uint8List>> toList() {
    return origin.transform(const _ToUint8List()).toList();
  }

  @override
  Future<Set<Uint8List>> toSet() {
    return origin.transform(const _ToUint8List()).toSet();
  }

  @override
  Stream<S> transform<S>(StreamTransformer<List<int>, S> streamTransformer) {
    return origin.transform<S>(streamTransformer);
  }

  @override
  Stream<Uint8List> where(bool Function(Uint8List event) test) {
    return origin.transform(const _ToUint8List()).where(test);
  }
}

class _ToUint8List extends Converter<List<int>, Uint8List> {
  const _ToUint8List();

  @override
  Uint8List convert(List<int> input) => Uint8List.fromList(input);

  @override
  Sink<List<int>> startChunkedConversion(Sink<Uint8List> sink) {
    return _Uint8ListConversionSink(sink);
  }
}

class _Uint8ListConversionSink implements Sink<List<int>> {
  const _Uint8ListConversionSink(this._target);

  final Sink<Uint8List> _target;

  @override
  void add(List<int> data) {
    _target.add(Uint8List.fromList(data));
  }

  @override
  void close() {
    _target.close();
  }
}

/**
 * The HTTP response wrapper.
 */
class HttpResponseWrapper extends IOSinkWrapper implements HttpResponse {
  HttpResponseWrapper(HttpResponse origin): super(origin);

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
  => _$closer != null ? _$closer: (_$closer = Completer());
  Completer _$closer;

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
  void writeln([Object obj = ""]) {
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
