//Copyright (C) 2021 Potix Corporation. All Rights Reserved.
//History: Sun Apr  4 19:22:11 CST 2021
// Author: tomyeh
part of rikulo_util;

/// Utilities related to invoations.
class InvokeUtil {
  /// Invokes the given function safely.
  /// By safely, we mean it will catch all exceptions and ignore them.
  static Future<T?> invokeSafely<T>(FutureOr<T> action()) async {
    try {
      return await action();
    } catch (_) {
    }
  }

  /// Invokes the given function safely.
  /// By safely, we mean it will catch all exceptions and ignore them.
  static Future<T?> invokeSafelyWith<T, A>(FutureOr<T> action(A arg), A arg) async {
    try {
      return await action(arg);
    } catch (_) {
    }
  }
}
