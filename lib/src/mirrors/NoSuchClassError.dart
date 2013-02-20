//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  13:02:31 PM
// Author: hernichen

part of rikulo_mirrors;

/** Exception thrown because of non-existing class */
class NoSuchClassError implements Exception {
  final message;
  const NoSuchClassError([this.message]);

  String toString() => (message == null) ? "Exception:" : "Exception: $message";
}
