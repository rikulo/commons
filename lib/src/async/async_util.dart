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
void defer(key, task(), {Duration min: const Duration(seconds: 1), Duration max}) {
  _deferrer.run(key, task, min, max);
}

/** Force all deferred task (queued by [defer]) to execute.
 * If the task given in [defer] returns an instance of Future, this method
 * will wait until it completes.
 */
Future flushDefers() => _deferrer.flush();

typedef _Task();

class _DeferInfo {
  Timer timer;
  final DateTime _startedAt;
  _Task task;

  _DeferInfo(this.timer, this.task): _startedAt = new DateTime.now();

  bool isAfter(Duration max)
  => max != null && _startedAt.add(max).isBefore(new DateTime.now());
}

class _Deferrer {
  final Map<dynamic, _DeferInfo> _defers = new HashMap();

  void run(key, task(), Duration min, Duration max) {
    final _DeferInfo di = _defers[key];
    if (di == null) {
      _defers[key] = new _DeferInfo(_startTimer(key, min), task);
      return;
    }

    di.timer.cancel();

    if (di.isAfter(max)) {
      _defers.remove(key);
      scheduleMicrotask(task);
    } else {
      di..task = task
        ..timer = _startTimer(key, min);
    }
  }

  Future flush() async {
    for (final key in new List.from(_defers.keys)) {
      final di = _defers.remove(key);
      if (di != null) {
        di.timer.cancel();
        await di.task();
      }
    }
  }

  Timer _startTimer(key, Duration min)
  => new Timer(min, () => (_defers.remove(key))?.task());
}
final _Deferrer _deferrer = new _Deferrer();
