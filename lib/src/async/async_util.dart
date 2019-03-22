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
 *     defer("cur.task", () {
 *       currentUser.save(["task"]); //a costly operation
 *     }, min: const Duration(seconds: 1), max: const Duration(seconds: 10));
 *     //then, it executes not faster than once per 10s,
 *     //and no later than 100s
 *
 * * [key] - used to identify [task]. If [key] is the same, we consider
 * the task is the same. If different, they are handled separately.
 * * [task] - the task. It can return `void`, `null` or an instance of [Future]
 * * [min] - specifies the minimal duration that the
 * given task will be executed. In short, the task will be invoked
 * [min] milliseconds later if no following invocation with the same key.
 * * [max] - specifies the maximal duration that
 * the given task will be executed. If given (i.e., not null), [task]
 * will be execute at least [max] milliseconds later even if there are
 * following invocations with the same key.
 */
void defer(key, FutureOr task(), {Duration min: const Duration(seconds: 1), Duration max}) {
  _deferrer.run(key, task, min, max);
}

/** Force all deferred task (queued by [defer]) to execute.
 * If the task given in [defer] returns an instance of Future, this method
 * will wait until it completes.
 * 
 * * [onAction] - (optional) If specified, it is called when
 * an action starts or finishes (end=true).
 * * [onError] - (optional) used to process the error thrown by a deferred task.
 * If not specified, the exception won't be caught and will terminate
 * this method.
 * * [repeatLater] - If specified, it will continue to flush any new deferred
 * function (registered via [defer] when flusing existing deferred functions).
 * Before continue, it will wait the duration specified in [repeatLater].
 * Default: null (not to repeat).
 */
Future flushDefers({void onAction(key, bool end),
    void onError(ex, StackTrace st), Duration repeatLater})
=> _deferrer.flush(onAction, onError, repeatLater);

/** Configures how to execute a deferred task.
 * 
 * Note: `onAction` and `onError` are available if it is caused by
 * the invocation of [flushDefers]. That is, they are passed from
 * the arguments when calling [flushDefers].
 * 
 * * [executor] - if specified, it is used to execute [task].
 * Otherwise, [task] was called directly.
 */
void configureDefers(
    {FutureOr executor(key, FutureOr task(),
        {void onAction(), void onError(ex, StackTrace st)})}) {
  _deferrer.executor = executor;
}

typedef FutureOr _Task();
typedef FutureOr _Executor(key, FutureOr task(),
    {void onAction(), void onError(ex, StackTrace st)});

class _DeferInfo {
  Timer timer;
  final DateTime _startAt;
  _Task task;

  _DeferInfo(this.timer, this.task): _startAt = DateTime.now();

  Duration getDelay(Duration min, Duration max) {
    if (max != null) {
      final remaining = max - DateTime.now().difference(_startAt);
      if (remaining < min)
        return remaining > Duration.zero ? remaining: null;
    }
    return min;
  }
}

class _Deferrer {
  Map<dynamic, _DeferInfo> _defers = HashMap<dynamic, _DeferInfo>();
  _Executor executor;

  void run(key, FutureOr task(), Duration min, Duration max) {
    final _DeferInfo di = _defers[key];
    if (di == null) {
      _defers[key] = _DeferInfo(_startTimer(key, min), task);
      return;
    }

    di.timer.cancel();

    final delay = di.getDelay(min, max);
    if (delay != null) {
      di..task = task
        ..timer = _startTimer(key, delay);
    } else {
      //force to run (even in a very busy environment)
      _defers.remove(key);
      Timer.run(task);
    }
  }

  Future flush(void onAction(key, bool end), void onError(ex, StackTrace st),
      Duration repeatLater) {
    if (_defers.isEmpty) return new Future.value();

    final defers = _defers;
    _defers = HashMap<dynamic, _DeferInfo>();
    final ops = <Future>[];

    for (final key in defers.keys) {
      try {
        final di = defers[key];
        di.timer.cancel();

        onAction?.call(key, false);
 
        if (executor != null) {
          final op = executor(key, di.task, onError: onError,
              onAction: onAction == null ? null: () => onAction(key, true));
          if (op is Future) ops.add(op);

        } else {
          var op = di.task();
          if (op is Future) {
            Future ft = op;
            if (onAction != null)
              ft = ft.then((_) => onAction(key, true));
            if (onError != null)
              ft = ft.catchError(onError);
            ops.add(ft);
          } else {
            onAction?.call(key, true);
          }
        }
      } catch (ex, st) {
        if (onError != null) onError(ex, st);
        else rethrow;
      }
    }

    Future result = Future.wait(ops); //wait => run in parallel
    if (repeatLater != null) //spec: null => not repeat
      result = result.then(
          (_) => new Future.delayed(repeatLater,
            () => flush(onAction, onError, repeatLater)));
    return result;
  }

  Timer _startTimer(key, Duration min)
  => Timer(min, () {
    final di = _defers.remove(key);
    return di == null ? null:
        executor != null ? executor(key, di.task): di.task();
  });
}
final _deferrer = _Deferrer();
