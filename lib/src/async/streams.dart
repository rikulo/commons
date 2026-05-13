//Copyright (C) 2021 Potix Corporation. All Rights Reserved.
//History: Sun Apr  4 17:56:35 CST 2021
// Author: tomyeh
part of rikulo_async;

/// Stream utilities
class StreamUtil {
  /// Returns the first element, or null if not element at all.
  /// Unlike [Stream.first], it won't throw [StateError].
  static Future<T?> first<T>(Stream<T> stream) {
    final c = Completer<T?>();
    late final StreamSubscription<T> sub;

    sub = stream.listen(
      (data) {
        if (!c.isCompleted) c.complete(data);
        InvokeUtil.invokeSafely(sub.cancel);
      },
      onError: (e, st) {
        if (!c.isCompleted) c.completeError(e, st);
      },
      onDone: () {
        if (!c.isCompleted) c.complete(null);
      },
      cancelOnError: true,
    );

    return c.future;
  }
}
