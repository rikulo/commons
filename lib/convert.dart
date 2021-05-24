//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 18, 2013 11:01:44 AM
// Author: tomyeh
library rikulo_convert;

import "dart:async" show Future, Stream;
import "dart:convert";
import "dart:io";

/// Reads the entire stream as a string using the given [Encoding].
///
/// + [maxLength] the maximal allowed length.
/// If omitted, no limitation at all.
/// If specified and the input is more than allowed, [PayloadException]
/// will be thrown.
Future<String> readAsString(Stream<List<int>> stream, 
    {Encoding encoding: utf8, int maxLength}) async {
  final result = <int>[];
  await for (final data in stream) {
    if (maxLength != null && (data.length + result.length) > maxLength)
      throw PayloadException("Too large");
    result.addAll(data);
  }
  return encoding.decode(result);
}

/// Reads the entire stream as a JSON string using the given [Encoding],
/// and then convert to an object.
///
/// + [maxLength] the maximal allowed length.
/// If omitted, no limitation at all.
/// If specified and the input is more than allowed, [PayloadException]
/// will be thrown.
Future<dynamic> readAsJson(Stream<List<int>> stream,
    {Encoding encoding: utf8, int maxLength}) async
=> json.decode(await readAsString(stream,
      encoding: encoding, maxLength: maxLength));

/// Exceptions thrown by [encodeAsString] and [encodeAsJson]
/// to indicate if the input stream is larger than allowed.
class PayloadException extends IOException {
  final String message;

  PayloadException(this.message);

  @override
  String toString() => message;
}
