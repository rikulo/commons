//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 18, 2013 11:01:44 AM
// Author: tomyeh
part of rikulo_io;

///A collection of I/O related utilities
class IOUtil {
  /** Utility function to synchronously decode a list of bytes.
   */
  static String decode(List<int> bytes, [Encoding encoding = Encoding.UTF_8]) {
    if (bytes.length == 0) return "";

    var string, error;
    var controller = new StreamController(sync: true);
    controller.stream
      .transform(new StringDecoder(encoding))
      .listen((data) => string = data,
        onError: (e) => error = e);
    controller.add(bytes);
    controller.close();
    if (error != null) throw error;
    return string; //note: it is done synchronously
  }

  /** Utility function to synchronously encode a String.
   * It will throw an exception if the encoding is invalid.
   */
  static List<int> encode(String string, [Encoding encoding = Encoding.UTF_8]) {
    if (string.length == 0) return [];

    var bytes;
    var controller = new StreamController(sync: true);
    controller.stream
      .transform(new StringEncoder(encoding))
      .listen((data) => bytes = data);
    controller.add(string);
    controller.close();
    return bytes;
  }

  /** Reads the entire stream as a string using the given [Encoding].
   */
  static Future<String> readAsString(Stream<List<int>> stream, 
      {Encoding encoding: Encoding.UTF_8}) {
    final List<int> result = [];
    return stream.listen((data) {
      result.addAll(data);
    }).asFuture().then((_) {
      return decode(result, encoding);
    });
  }
  /** Reads the entire stream as a JSON string using the given [Encoding],
   * and then convert to an object.
   */
  static Future<dynamic> readAsJson(Stream<List<int>> stream,
      {Encoding encoding: Encoding.UTF_8})
  => readAsString(stream, encoding: encoding).then((data) => Json.parse(data));
}