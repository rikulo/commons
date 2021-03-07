//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Feb 04, 2013  3:45:58 PM
// Author: tomyeh

part of rikulo_async;

/**
 * An object that can be used as the target of the stream provided by [StreamProvider].
 */
abstract class StreamTarget<T> {
  /** Adds an event listener.
   */
  void addEventListener(String type, void listener(T event)?);
  /** Removes an event listener.
   */
  void removeEventListener(String type, void listener(T event)?);
}

/**
 * An object that can be used as the target of the stream provided by [CapturableStreamProvider].
 */
abstract class CapturableStreamTarget<T> {
  /** Adds an event listener.
   *
   * * [useCapture] is applicable only if the event is caused by a DOM event. Otherwise, it is ignored.
   */
  void addEventListener(String type, void listener(T event)?, {bool useCapture: false});
  /** Removes an event listener.
   *
   * * [useCapture] is applicable only if the event is caused by a DOM event. Otherwise, it is ignored.
   */
  void removeEventListener(String type, void listener(T event)?, {bool useCapture: false});
}

/**
 * A factory to expose [StreamTarget]'s events as Streams.
 */
class StreamProvider<T> {
  final String _type;

  const StreamProvider(this._type);

  /**
   * Gets a [Stream] for this event type, on the specified target.
   */
  Stream<T> forTarget(StreamTarget<T> target) {
    return _Stream(target, _type);
  }
}

/**
 * A factory to expose [CapturableStreamTarget]'s events as Streams.
 */
class CapturableStreamProvider<T> {
  final String _type;

  const CapturableStreamProvider(this._type);

  /**
   * Gets a [Stream] for this event type, on the specified target.
   *
   * * [useCapture] is applicable only if the view event is caused by a DOM event.
   */
  Stream<T> forTarget(CapturableStreamTarget<T> target, {bool useCapture: false}) {
    return _CapturableStream(target, _type, useCapture);
  }
}

class _Stream<T> extends Stream<T> {
  final String _type;
  final StreamTarget<T> _target;

  _Stream(this._target, this._type);

  @override
  StreamSubscription<T> listen(void onData(T event)?,
          {Function? onError, void onDone()?, bool? cancelOnError})
    => _StreamSubscription<T>(this._target, this._type, onData);
}

class _CapturableStream<T> extends Stream<T> {
  final String _type;
  final CapturableStreamTarget<T> _target;
  final bool _useCapture;

  _CapturableStream(this._target, this._type, this._useCapture);

  @override
  StreamSubscription<T> listen(void onData(T event)?,
        {Function? onError, void onDone()?, bool? cancelOnError})
    => _CapturableStreamSubscription<T>(
          this._target, this._type, onData, this._useCapture);
}

typedef void _OnData<T>(T event);

abstract class _StreamSubscriptionBase<T> extends StreamSubscription<T> {
  int _pauseCount = 0;
  final String _type;
  _OnData<T>? _onData;

  _StreamSubscriptionBase(this._type, this._onData) {
    _tryResume();
  }

  @override
  Future cancel() {
    if (!_canceled) {
      _unlisten();
      // Clear out the target to indicate this is complete.
      _onData = null;
    }
    return Future.value();
  }

  @override
  void onData(void handleData(T event)?) {
    if (_canceled) {
      throw StateError("Subscription has been canceled.");
    }
    // Remove current event listener.
    _unlisten();

    _onData = handleData;
    _tryResume();
  }

  /// Has no effect.
  @override
  void onError(Function? handleError) {}

  /// Has no effect.
  @override
  void onDone(void handleDone()?) {}

  @override
  void pause([Future? resumeSignal]) {
    if (_canceled) return;
    ++_pauseCount;
    _unlisten();

    if (resumeSignal != null) {
      resumeSignal.whenComplete(resume);
    }
  }

  @override
  bool get isPaused => _pauseCount > 0;

  @override
  void resume() {
    if (_canceled || !isPaused) return;
    --_pauseCount;
    _tryResume();
  }

  void _tryResume() {
    if (_onData != null && !isPaused)
      _add();
  }

  void _unlisten() {
    if (_onData != null)
      _remove();
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    // We just need a future that will never succeed or fail.
    return Completer<E>().future;
  }

  //deriving to override//
  bool get _canceled;
  void _add();
  void _remove();
}

class _StreamSubscription<T> extends _StreamSubscriptionBase<T> {
  final StreamTarget<T> _target;
  bool _wasCanceled = false;

  _StreamSubscription(this._target, String type, void onData(T event)?):
    super(type, onData);

  @override
  Future cancel() {
    super.cancel(); //always null

    // Clear out the target to indicate this is complete.
    _wasCanceled = true;
    return Future.value();
  }

  @override
  bool get _canceled => _wasCanceled;
  @override
  void _add() {
    _target.addEventListener(_type, _onData);
  }
  @override
  void _remove() {
    _target.removeEventListener(_type, _onData);
  }
}

class _CapturableStreamSubscription<T> extends _StreamSubscriptionBase<T> {
  final CapturableStreamTarget<T> _target;
  final bool _useCapture;
  bool _wasCanceled = false;

  _CapturableStreamSubscription(this._target, String type, void onData(T event)?, this._useCapture):
    super(type, onData);

  @override
  Future cancel() {
    super.cancel(); //always null
    _wasCanceled = true;
    // Clear out the target to indicate this is complete.
    return Future.value();
  }

  @override
  bool get _canceled => _wasCanceled;
  @override
  void _add() {
    _target.addEventListener(_type, _onData, useCapture: _useCapture);
  }
  @override
  void _remove() {
    _target.removeEventListener(_type, _onData, useCapture: _useCapture);
  }
}
