//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 26, 2013 11:05:45 AM
// Author: tomyeh
part of rikulo_async;

///A Stream wrapper
class StreamWrapper<T> implements Stream<T> {
  StreamWrapper(Stream<T> origin): _origin = origin;

  ///The origin stream
  Stream<T> get origin => _origin;
  final Stream<T> _origin;

  @override
  bool get isBroadcast => origin.isBroadcast;
  @override
  Stream<T> asBroadcastStream({
    void onListen(StreamSubscription<T> subscription),
    void onCancel(StreamSubscription<T> subscription)})
    => origin.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  @override
  StreamSubscription<T> listen(void onData(T event),
  { Function onError, void onDone(), bool cancelOnError})
  => origin.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  @override
  Stream<T> where(bool test(T event)) => origin.where(test); 
  @override
  Stream<S> map<S>(S convert(T event)) => origin.map(convert);
  @override
  Stream<E> asyncMap<E>(FutureOr<E> convert(T event))
  => origin.asyncMap(convert);
  @override
  Stream<E> asyncExpand<E>(Stream<E> convert(T event))
  => origin.asyncExpand(convert);
  @override
  Stream<T> handleError(Function handle, { bool test(error) })
  => origin.handleError(handle, test: test);
  @override
  Stream<S> expand<S>(Iterable<S> convert(T value)) => origin.expand(convert);
  @override
  Future pipe(StreamConsumer<T> streamConsumer) => origin.pipe(streamConsumer);
  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer)
  => origin.transform(streamTransformer);
  @override
  Future<T> reduce(T combine(T previous, T element)) => origin.reduce(combine);
  @override
  Future<S> fold<S>(S initialValue, S combine(S previous, T element))
  => origin.fold(initialValue, combine);
  @override
  Future<bool> contains(Object match) => origin.contains(match);
  @override
  Future forEach(void action(T element)) => origin.forEach(action);
  @override
  Future<bool> every(bool test(T element)) => origin.every(test);
  @override
  Future<bool> any(bool test(T element)) => origin.any(test);
  @override
  Future<int> get length => origin.length;
  @override
  Future<bool> get isEmpty => origin.isEmpty;
  @override
  Future<List<T>> toList() => origin.toList();
  @override
  Future<Set<T>> toSet() => origin.toSet();
  @override
  Future<E> drain<E>([E futureValue]) => origin.drain(futureValue);
  @override
  Stream<T> take(int count) => origin.take(count);
  @override
  Stream<T> takeWhile(bool test(T value)) => origin.takeWhile(test);
  @override
  Stream<T> skip(int count) => origin.skip(count);
  @override
  Stream<T> skipWhile(bool test(T value)) => origin.skipWhile(test);
  @override
  Stream<T> distinct([bool equals(T previous, T next)]) => origin.distinct(equals);
  @override
  Future<T> get first => origin.first;
  @override
  Future<T> get last => origin.last;
  @override
  Future<T> get single => origin.single;
  @override
  Future<T> firstWhere(bool test(T element), {T orElse()})
  => origin.firstWhere(test, orElse: orElse);
  @override
  Future<T> lastWhere(bool test(T element), {T orElse()})
  => origin.lastWhere(test, orElse: orElse);
  @override
  Future<T> singleWhere(bool test(T element), {T orElse()})
  => origin.singleWhere(test, orElse: orElse);
  @override
  Future<T> elementAt(int index) => origin.elementAt(index);
  @override
  Future<String> join([String separator = ""]) => origin.join(separator);
  @override
  Stream<T> timeout(Duration timeLimit, {void onTimeout(EventSink<T> sink)})
  => origin.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Stream<R> cast<R>() => origin.cast();
}

///The StreamConsumer wrapper
class StreamConsumerWrapper<S> implements StreamConsumer<S> {
  StreamConsumerWrapper(StreamConsumer<S> origin): _origin = origin;

  ///The original stream consumer
  StreamConsumer<S> get origin => _origin;
  final StreamConsumer<S> _origin;

  @override
  Future addStream(Stream<S> stream) => origin.addStream(stream);
  @override
  Future close() => origin.close();
}
