//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Aug 02, 2013  5:37:48 PM
// Author: tomyeh
library rikulo_async.defer;

import "dart:async";
import "dart:collection";

/** Defers the execution of a [task].
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
 * * [key] - used to identify [task]. If both [category] and [key] are
 * the same, we consider the task is the same.
 * If different, they are handled separately.
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
     String? category}) {
  final dfkey = _DeferKey(key, category),
    di = _defers.remove(dfkey) as _DeferInfo<T>?;
  if (di == null) {
    _defers[dfkey] = _DeferInfo<T>(_startTimer(dfkey, min), task);
  } else {
    _defers[dfkey] = di; //put back; remove-and-add, so dfkey is the last one
    di..timer.cancel()
      ..task = task
      ..timer = _startTimer(dfkey, di.getDelay(min, max));
  }
}

/// Cancels the deferred execution of the given [key].
/// Returns true if the task is not yet executed.
bool cancelDeferred(key, {String? category}) {
  final di = _defers.remove(_DeferKey(key, category));
  if (di == null) return false;

  di.timer.cancel();
  return true;
}

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
FutureOr flushDefers({void onActionStart(key, String? category)?,
    void onActionDone(key, String? category)?,
    void onError(ex, StackTrace st)?, Duration? repeatLater}) {
  if (_defers.isEmpty && _runnings.isEmpty) return null;

  final ops = <Future>[],
    defers = _defers;
  _defers = HashMap<_DeferKey, _DeferInfo>();

  for (final dfkey in defers.keys) {
    try {
      final di = defers[dfkey]!;
      di.timer.cancel();

      final key = dfkey.key,
        category = dfkey.category;
      onActionStart?.call(key, category);

      final exec = _executor;
      if (exec != null) {
        final op = exec(key, di.task, category, onError: onError,
            onActionDone: onActionDone == null ?
              null: () => onActionDone(key, category));
        if (op is Future) ops.add(op);

      } else {
        var op = di.task(key);
        if (op is Future) {
          Future ft = op;
          if (onActionDone != null)
            ft = ft.then((_) => onActionDone(key, category));
          if (onError != null)
            ft = ft.catchError(onError);
          ops.add(ft);
        } else {
          onActionDone?.call(key, category);
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
        (_) => Future.delayed(repeatLater,
          () => flushDefers(onActionStart: onActionStart,
            onActionDone: onActionDone, onError: onError,
            repeatLater: repeatLater)));
  return result;
}

/** Configures how to execute a deferred task.
 * 
 * Note: `onActionDone` and `onError` are available if it is caused by
 * the invocation of [flushDefers]. That is, they are passed from
 * the arguments when calling [flushDefers].
 * 
 * * [executor] - if specified, it is used to execute [task].
 * Otherwise, [task] was called directly.
 * * [executable] - if specified, it will be called before executing a task.
 * And, if it returns null, the task will be executed as normal.
 * On the other hand, if it returns a duration, `defer` will pause the given
 * duration and then start over again.
 * It is usually to defer the execution further when the system is busy.
 * * [maxBusy] - how long to wait before forcing a new execution to start
 * if there is an execution of the same [key] still executing.
 * Default: null (forever).
 * When a task is about to execute, we'll check if the previous execution
 * is done. If not, it will wait the time specified in [maxBusy].
 * 
 * Note: the signature of `task`: `FutureOr task(key)`.
 * Thus, you must pass `key` to it when calling `task(key)`.
 */
void configureDefers(
    {FutureOr executor(key, Function task, String? category,
        {void onActionDone()?, void onError(ex, StackTrace st)?})?,
     Duration executable(int runningCount)?, Duration? maxBusy}) {
  _executor = executor;
  _executable = executable;
  _maxBusy = maxBusy;
}

//typedef FutureOr _Task<T>(T key);
typedef FutureOr _Executor(key, Function task, String? category,
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
  final String? category;

  _DeferKey(this.key, this.category);

  @override
  int get hashCode => key.hashCode ^ category.hashCode; //key can be null...
  @override
  bool operator==(o)
  => o is _DeferKey && o.key == key && o.category == category;
  @override
  String toString() => "[$key, $category]";
}

Timer _startTimer(_DeferKey dfkey, Duration min) => Timer(min,
  () async {
    final di = _defers.remove(dfkey);
    if (di == null) return;

    Duration? deferAgain;
    if (_busy.contains(dfkey)) {
      final mbusy = _maxBusy;
      if (mbusy == null || DateTime.now().difference(di.startAt) < mbusy)
        deferAgain = min;
    }

    if (deferAgain == null) {
      final executable = _executable;
      if (executable != null)
        deferAgain = executable(_runnings.length);
          //not _busy.length since only Future matters
    }

    if (deferAgain != null) {
      _defers[dfkey] = di; //put back
      di.timer = _startTimer(dfkey, //do it again later
          deferAgain < const Duration(milliseconds: 100) ?
            const Duration(milliseconds: 100): deferAgain);
      return;
    }

    Future? op;
    _busy.add(dfkey);
    try {
      final key = dfkey.key,
        task = di.task,
        exec = _executor,
        r = exec != null ? exec(key, task, dfkey.category): task(key);
      if (r is Future) {
        _runnings.add(op = r);
        await op;
      }
    } finally {
      if (op != null) _runnings.remove(op);
      _busy.remove(dfkey);
    }
  });

var _defers = HashMap<_DeferKey, _DeferInfo>();
_Executor? _executor;
Duration Function(int runningCount)? _executable;
Duration? _maxBusy;
final _runnings = <Future>[],
  _busy = HashSet<_DeferKey>();
