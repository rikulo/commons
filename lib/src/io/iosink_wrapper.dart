//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 26, 2013 11:09:11 AM
// Author: tomyeh
part of rikulo_io;

///The IOSink wrapper
class IOSinkWrapper<T> extends StreamConsumerWrapper<List<int>, T> implements IOSink<T> {
  IOSinkWrapper(IOSink origin) : super(origin);

  ///The original IO sink
  IOSink<T> get origin => super.origin as IOSink;

  //IOSink//
  @override
  Encoding get encoding => origin.encoding;
  @override
  void set encoding(Encoding encoding) {
    origin.encoding = encoding;
  }

  @override
  void writeBytes(List<int> data) {
    origin.writeBytes(data);
  }

  @override
  Future<T> consume(Stream<List<int>> stream) => origin.consume(stream);
  @override
  Future<T> addStream(Stream<List<int>> stream) => origin.addStream(stream);
  /** *Deprecated*: use [addStream] instead. */
  @override
  Future<T> writeStream(Stream<List<int>> stream) => origin.writeStream(stream);

  @override
  Future close() => origin.close();
  @override
  Future<T> get done => origin.done.then((_) => this);

  //StringSink//
  @override
  void write(Object obj) {
    origin.write(obj);
  }
  @override
  void writeAll(Iterable objects, [String separator = ""]) {
    origin.writeAll(objects, separator);
  }
  @override
  void writeln([Object obj = ""])  {
    origin.writeln(obj);
  }
  @override
  void writeCharCode(int charCode) {
    origin.writeCharCode(charCode);
  }
}
