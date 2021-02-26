//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 02, 2013  5:37:48 PM
// Author: tomyeh

part of rikulo_async;

/** Defers the execution of a task.
 * If the key is the same, the task in the second invocation will override
 * the previous. In other words, the previous task is canceled.
 *
 * It is useful if you have a task that happens frequently but you prefer
 * not to execute them all but only the once for a while (because of costly).
 * For example,
 *
 *     defer("cur.task", (key) {
 *       currentUser.save(["task"]); //a costly operation
 *     }, min: const Duration(seconds: 1), max: const Duration(seconds: 10));
 *     //then, it executes not faster than once per 10s,
 *     //and no later than 100s
 *
 * * [key] - used to identify [task]. If both [categoryKey] and [key] are
 * the same, we consider the task is the same. If different, they are handled separately.
 * * [task] - the task. It can return `void`, `null` or an instance of [Future]
 * * [min] - specifies the minimal duration that the
 * given task will be executed. You can't specify null here. Default: 1 second.
 * That is, the task will be invoked [min] milliseconds later
 * if no following invocation with the same key.
 * * [max] - specifies the maximal duration that
 * the given task will be executed. Default: null.
 * If specified, [task]
 * will be execute at least [max] milliseconds later even if there are
 * following invocations with the same key.
 * If not specified, it will keep waiting.
 */
void defer<T>(T key, FutureOr task(T key),
    {Duration min: const Duration(seconds: 1), Duration? max,
     String? categoryKey}) {
  _deferrer.run(key, task, min, max, categoryKey);
}

/// Cancels the deferred execution of the given [key].
/// Returns true if the task is not yet executed.
bool cancelDeferred(key, {String? categoryKey})
=> _deferrer.cancel(key, categoryKey);

/** Force all deferred task (queued by [defer]) to execute.
 * If the task given in [defer] returns an instance of Future, this method
 * will wait until it completes.
 * 
 * * [onActionStart] - (optional) If specified, it is called when
 * an action starts.
 * * [onActionDone] - (optional) If specified, it is called when
 * an action has been done.
 * * [onError] - (optional) used to process the error thrown by a deferred task.
 * If not specified, the exception won't be caught and will terminate
 * this method.
 * * [repeatLater] - If specified, it will continue to flush any new deferred
 * function (registered via [defer] when flusing existing deferred functions).
 * Before continue, it will wait the duration specified in [repeatLater].
 * Default: null (not to repeat).
 */
FutureOr flushDefers({void onActionStart(key, String? categoryKey)?,
    void onActionDone(key, String? categoryKey)?,
    void onError(ex, StackTrace st)?, Duration? repeatLater})
=> _deferrer.flush(onActionStart, onActionDone, onError, repeatLater);

/** Configures how to execute a deferred task.
 * 
 * Note: `onActionDone` and `onError` are available if it is caused by
 * the invocation of [flushDefers]. That is, they are passed from
 * the arguments when calling [flushDefers].
 * 
 * * [executor] - if specified, it is used to execute [task].
 * Otherwise, [task] was called directly.
 * * [maxBusy] - how long to wait before forcing a new execution to start.
 * Default: null (forever).
 * When a task is about to execute, we'll check if the previous execution
 * is done. If not, it will wait the time specified in [maxBusy].
 * 
 * Note: the signature of `task`: `FutureOr task(key)`.
 * Thus, you must pass `key` to it when calling `task(key)`.
 */
void configureDefers(
    {FutureOr executor(key, Function? task,
        {void onActionDone()?, void onError(ex, StackTrace st)?})?,
     Duration? maxBusy}) {
  _deferrer
    ..executor = executor
    ..maxBusy = maxBusy;
}

//typedef FutureOr _Task<T>(T key);
typedef FutureOr _Executor(key, Function? task,
    {void onActionDone()?, void onError(ex, StackTrace st)?});

class _DeferInfo<T> {
  Timer timer;
  final DateTime startAt;
  Function/*_Task<T>*/ task; //due to Dart's limitation, use Function here

  _DeferInfo(this.timer, this.task): startAt = DateTime.now();

  Duration getDelay(Duration min, Duration? max) {
    if (max != null) {
      final remaining = max - DateTime.now().difference(startAt);
      if (remaining < min)
        return remaining > Duration.zero ? remaining: Duration.zero;
    }
    return min;
  }
}

class _DeferKey<T> {
  final T key;
  final String? categoryKey;

  _DeferKey(this.key, this.categoryKey);

  @override
  int get hashCode => key.hashCode + categoryKey.hashCode; //key can be null...
  @override
  bool operator==(o)
  => o is _DeferKey && o.key == key && o.categoryKey == categoryKey;
  @override
  String toString() => "[$key, $categoryKey]";
}

class _Deferrer {
  var _defers = HashMap<_DeferKey, _DeferInfo>();
  _Executor? executor;
  Duration? maxBusy;
  final _runnings = <Future>[];
  final _busy = new HashSet<_DeferKey>();

  void run<T>(T key, FutureOr task(T key), Duration min, Duration? max,
      String? categoryKey) {
    final dfkey = new _DeferKey(key, categoryKey);
    final di = _defers[dfkey] as _DeferInfo<T?>?;
    if (di == null) {
      _defers[dfkey] = _DeferInfo<T>(_startTimer(dfkey, min), task);
      return;
    }

    di..timer.cancel()
      ..task = task
      ..timer = _startTimer(dfkey, di.getDelay(min, max));
  }

  bool cancel(key, String? categoryKey) {
    final di = _defers.remove(new _DeferKey(key, categoryKey));
    if (di == null) return false;

    di.timer.cancel();
    return true;
  }

  FutureOr flush(void onActionStart(key, String? categoryKey)?,
      void onActionDone(key, String? categoryKey)?,
      void onError(ex, StackTrace st)?,
      Duration? repeatLater) {
    if (_defers.isEmpty && _runnings.isEmpty) return null;

    final ops = <Future>[];
    final defers = _defers;
    _defers = HashMap<_DeferKey, _DeferInfo>();

    for (final dfkey in defers.keys) {
      try {
        final di = defers[dfkey]!;
        di.timer.cancel();

        final key = dfkey.key;
        final categoryKey = dfkey.categoryKey;
        onActionStart?.call(key, categoryKey);
 
        if (executor != null) {
          final op = executor!(key, di.task, onError: onError,
              onActionDone: onActionDone == null ?
                null: () => onActionDone(key, categoryKey));
          if (op is Future) ops.add(op);

        } else {
          var op = di.task(key);
          if (op is Future) {
            Future ft = op;
            if (onActionDone != null)
              ft = ft.then((_) => onActionDone(key, categoryKey));
            if (onError != null)
              ft = ft.catchError(onError);
            ops.add(ft);
          } else {
            onActionDone?.call(key, categoryKey);
          }
        }
      } catch (ex, st) {
        if (onError != null) onError(ex, st);
        else rethrow;
      }
    }

    ops.addAll(_runnings);
    Future result = Future.wait(ops); //wait => run in parallel
    if (repeatLater != null) //spec: null => not repeat
      result = result.then(
          (_) => new Future.delayed(repeatLater,
            () => flush(onActionStart, onActionDone, onError, repeatLater)));
    return result;
  }

  Timer _startTimer(_DeferKey dfkey, Duration min)
  => Timer(min, () async {
    final di = _defers.remove(dfkey);
    if (di == null) return;
    if (_busy.contains(dfkey)
    && (maxBusy == null || DateTime.now().difference(di.startAt) < maxBusy!)) {
      _defers[dfkey] = di; //put back
      di.timer = _startTimer(dfkey, //do it again later
          min < const Duration(milliseconds: 100) ?
            const Duration(milliseconds: 100): min);
      return;
    }

    Future? op;
    _busy.add(dfkey);
    try {
      final key = dfkey.key;
      final task = di.task;
      final r = executor != null ? executor!(key, task): task(key);
      if (r is Future) {
        _runnings.add(op = r);
        await op;
      }
    } finally {
      if (op != null) _runnings.remove(op);
      _busy.remove(dfkey);
    }
  });

}
final _deferrer = _Deferrer();
