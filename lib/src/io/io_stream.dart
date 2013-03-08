//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 26, 2013 11:09:11 AM
// Author: tomyeh
part of rikulo_io;

///The IOSink wrapper
class IOSinkWrapper<T> extends StreamConsumerWrapper<List<int>, T> implements IOSink<T> {
  IOSinkWrapper(IOSink origin) : super(origin);

  ///The original IO sink
  IOSink<T> get origin => super.origin as IOSink;

  @override
  Future<T> addStream(Stream<List<int>> stream) => origin.addStream(stream);
  @override
  void add(List<int> data) {
    origin.add(data);
  }
  @override
  void addString(String string, [Encoding encoding = Encoding.UTF_8]) {
    origin.addString(string, encoding);
  }
  @override
  void close() {
    origin.close();
  }
  @override
  Future<T> get done => origin.done.then((_) => this);
}
