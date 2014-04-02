//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 26, 2013 11:09:11 AM
// Author: tomyeh
part of rikulo_io;

/** The IOSink wrapper.
 *
 * Notice: it proxies every invocation to [origin]. Thus, if you'd like to
 * override [write] to write some other place, you have to override all
 * `add` and `write` methods (such as [writeln] and so on)
 */
class IOSinkWrapper extends StreamConsumerWrapper<List<int>> implements IOSink {
  IOSinkWrapper(IOSink origin) : super(origin);

  ///The original IO sink
  IOSink get origin => super.origin as IOSink;

  //IOSink//
  @override
  Encoding get encoding => origin.encoding;
  @override
  void set encoding(Encoding encoding) {
    origin.encoding = encoding;
  }

  @override
  void add(List<int> data) {
    origin.add(data);
  }
  @override
  void addError(error, [StackTrace stackTrace]) {
    origin.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<List<int>> stream) => origin.addStream(stream);

  @override
  Future flush() => origin.close();
  @override
  Future close() => origin.close();
  @override
  Future get done => origin.done.then((_) => this);

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
