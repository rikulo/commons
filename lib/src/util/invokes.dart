//Copyright (C) 2021 Potix Corporation. All Rights Reserved.
//History: Sun Apr  4 19:22:11 CST 2021
// Author: tomyeh
part of rikulo_util;

/// Utilities related to invocations.
class InvokeUtil {
  /// Invokes [action], catching any exception it throws.
  /// If [onError] is given, it is called with the exception;
  /// otherwise the exception is silently ignored.
  static Future<T?> invokeSafely<T>(FutureOr<T?> Function() action,
      {void onError(ex)?}) async {
    try {
      return await action();
    } catch (ex) {
      onError?.call(ex);
    }
  }

  /// Invokes [action], catching any exception it throws.
  /// If [onError] is given, it is called with the exception;
  /// otherwise the exception is silently ignored.
  static Future<T?> invokeSafelyWith<T, A>(
      FutureOr<T?> Function(A arg) action, A arg,
      {void onError(ex)?}) async {
    try {
      return await action(arg);
    } catch (ex) {
      onError?.call(ex);
    }
  }
}
