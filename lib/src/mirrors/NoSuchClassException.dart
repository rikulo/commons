//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  13:02:31 PM
// Author: hernichen

/** Exception thrown because of non-existing class */
class NoSuchClassException implements Exception {
  final message;
  const NoSuchClassException([this.message]);

  String toString() => (message == null) ? "Exception:" : "Exception: $message";
}
