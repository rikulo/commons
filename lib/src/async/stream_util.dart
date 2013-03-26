//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Mar 26, 2013  9:22:20 AM
// Author: tomyeh
part of rikulo_async;

///A collection of [Stream] utilities
class StreamUtil {
  /** Reads the entire stream as a string using the given [Encoding].
   */
  static Future<String> readAsString(Stream<List<int>> stream, {Encoding encoding: Encoding.UTF_8,
      void onError(AsyncError error)}) {
    final completer = new Completer<String>();
    final List<int> result = [];
    stream.listen((data) {
      result.addAll(data);
    }, onDone: () {
      completer.complete(EncodingUtil.decode(result, encoding));
      result.clear();
    }, onError: onError);
    return completer.future;
  }
  /** Reads the entire stream as a JSON string using the given [Encoding],
   * and then convert to an object.
   */
  static Future<dynamic> readAsJson(Stream<List<int>> stream, {Encoding encoding: Encoding.UTF_8,
      void onError(AsyncError error)})
  => readAsString(stream, encoding: encoding, onError: onError)
    .then((data) => Json.parse(data));
}
