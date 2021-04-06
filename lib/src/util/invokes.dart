//Copyright (C) 2021 Potix Corporation. All Rights Reserved.
//History: Sun Apr  4 19:22:11 CST 2021
// Author: tomyeh
part of rikulo_util;

/// Utilities related to invoations.
class InvokeUtil {
  /// Invokes the given function safely.
  /// By safely, we mean it will catch all exceptions and ignore them.
  static FutureOr<T> invokeSafely<T>(FutureOr<T> action()) async {
    try {
      return await action();
    } catch (_) {
    }
  }
}
