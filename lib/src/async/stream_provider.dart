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
  void addEventListener(String type, void listener(T event));
  /** Removes an event listener.
   */
  void removeEventListener(String type, void listener(T event));
}

/**
 * An object that can be used as the target of the stream provided by [CapturableStreamProvider].
 */
abstract class CapturableStreamTarget<T> {
  /** Adds an event listener.
   *
   * * [useCapture] is applicable only if the event is caused by a DOM event. Otherwise, it is ignored.
   */
  void addEventListener(String type, void listener(T event), {bool useCapture: false});
  /** Removes an event listener.
   *
   * * [useCapture] is applicable only if the event is caused by a DOM event. Otherwise, it is ignored.
   */
  void removeEventListener(String type, void listener(T event), {bool useCapture: false});
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
  Stream<T> forTarget(StreamTarget target) {
    return new _Stream(target, _type);
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
  Stream<T> forTarget(CapturableStreamTarget target, {bool useCapture: false}) {
    return new _CapturableStream(target, _type, useCapture);
  }
}

abstract class _AbstractStream<T> extends Stream<T> {
  final String _type;

  _AbstractStream(this._type);

  // events are inherently multi-subscribers.
  Stream<T> asMultiSubscriberStream() => this;
}

class _Stream<T> extends _AbstractStream<T> {
  final StreamTarget _target;

  _Stream(this._target, String type): super(type);

  StreamSubscription<T> listen(void onData(T event),
      {void onError(AsyncError error), void onDone(), bool unsubscribeOnError})
    => new _StreamSubscription<T>(this._target, this._type, onData);
}

class _CapturableStream<T> extends _AbstractStream<T> {
  final CapturableStreamTarget _target;
  final bool _useCapture;

  _CapturableStream(this._target, String type, this._useCapture): super(type);

  StreamSubscription<T> listen(void onData(T event),
      {void onError(AsyncError error), void onDone(), bool unsubscribeOnError})
    => new _CapturableStreamSubscription<T>(
      this._target, this._type, onData, this._useCapture);
}

abstract class _AbstractStreamSubscription<T> extends StreamSubscription<T> {
  int _pauseCount = 0;
  final String _type;
  var _onData;

  _AbstractStreamSubscription(this._type, this._onData) {
    _tryResume();
  }

  void cancel() {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }

    _unlisten();
    // Clear out the target to indicate this is complete.
    _onData = null;
  }

  void onData(void handleData(T event)) {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    // Remove current event listener.
    _unlisten();

    _onData = handleData;
    _tryResume();
  }

  /// Has no effect.
  void onError(void handleError(AsyncError error)) {}

  /// Has no effect.
  void onDone(void handleDone()) {}

  void pause([Future resumeSignal]) {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    ++_pauseCount;
    _unlisten();

    if (resumeSignal != null) {
      resumeSignal.whenComplete(resume);
    }
  }

  bool get _paused => _pauseCount > 0;

  void resume() {
    if (_canceled) {
      throw new StateError("Subscription has been canceled.");
    }
    if (!_paused) {
      throw new StateError("Subscription is not paused.");
    }
    --_pauseCount;
    _tryResume();
  }

  void _tryResume() {
    if (_onData != null && !_paused)
      _add();
  }

  void _unlisten() {
    if (_onData != null)
      _remove();
  }

  //deriving to override//
  bool get _canceled;
  void _add();
  void _remove();
}

class _StreamSubscription<T> extends _AbstractStreamSubscription<T> {
  StreamTarget _target;

  _StreamSubscription(this._target, String type, void onData(T event)):
    super(type, onData);

  void cancel() {
    super.cancel();

    // Clear out the target to indicate this is complete.
    _target = null;
  }

  bool get _canceled => _target == null;
  void _add() {
    _target.addEventListener(_type, _onData);
  }
  void _remove() {
    _target.removeEventListener(_type, _onData);
  }
}

class _CapturableStreamSubscription<T> extends _AbstractStreamSubscription<T> {
  CapturableStreamTarget _target;
  final bool _useCapture;

  _CapturableStreamSubscription(this._target, String type, void onData(T event), this._useCapture):
    super(type, onData);

  void cancel() {
    super.cancel();

    // Clear out the target to indicate this is complete.
    _target = null;
  }

  bool get _canceled => _target == null;
  void _add() {
    _target.addEventListener(_type, _onData, useCapture: _useCapture);
  }
  void _remove() {
    _target.removeEventListener(_type, _onData, useCapture: _useCapture);
  }
}
