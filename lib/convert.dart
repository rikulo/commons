//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 18, 2013 11:01:44 AM
// Author: tomyeh
library rikulo_convert;

import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:typed_data";

/// Reads the entire stream as a string using the given [Encoding].
///
/// + [maxLength] — maximum allowed length.
/// If null (default), no limit.
/// If the input exceeds it, [PayloadException] is thrown.
Future<String> readAsString(Stream<List<int>> stream, 
    {Encoding encoding = utf8, int? maxLength}) async {
  final result = BytesBuilder(copy: false);
  await for (final chunk in stream) {
    int newlen;
    if (maxLength != null
    && (newlen = chunk.length + result.length) > maxLength)
      throw PayloadException("Over $maxLength ($newlen)");
    result.add(chunk);
  }
  return encoding.decode(result.takeBytes());
}

/// Reads the entire stream as a JSON string using the given [Encoding],
/// and then converts to an object.
///
/// + [maxLength] — maximum allowed length.
/// If null (default), no limit.
/// If the input exceeds it, [PayloadException] is thrown.
Future<dynamic> readAsJson(Stream<List<int>> stream,
    {Encoding encoding = utf8, int? maxLength}) async
=> json.decode(await readAsString(stream,
      encoding: encoding, maxLength: maxLength));

/// Exception thrown by [readAsString] and [readAsJson] when the input
/// stream exceeds the allowed length.
class PayloadException extends IOException {
  final String message;

  PayloadException(this.message);

  @override
  String toString() => message;
}
