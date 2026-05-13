//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  13:02:31 PM
// Author: hernichen

part of rikulo_mirrors;

/// Exception thrown because of non-existing class.
@Deprecated('rikulo_mirrors uses dart:mirrors and is unsupported on AOT/web. Consider package:reflectable or code generation.')
class NoSuchClassError implements Exception {
  final message;
  const NoSuchClassError([this.message]);

  @override
  String toString() => (message == null) ? "No such class" : "No such class: $message";
}

/// Exception thrown when an object cannot be coerced to the target type.
@Deprecated('rikulo_mirrors uses dart:mirrors and is unsupported on AOT/web. Consider package:reflectable or code generation.')
class CoercionError implements Exception {
  final message;
  final targetType;
  const CoercionError([this.message, this.targetType]);

  @override
  String toString() => (message == null) ? "Coercion error" : "Coercion error: $message => $targetType";
}
