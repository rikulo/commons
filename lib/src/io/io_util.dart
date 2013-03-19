//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Mon, Mar 18, 2013 11:01:44 AM
// Author: tomyeh
part of rikulo_io;

/// Utility function to synchronously decode a list of bytes.
String decodeString(List<int> bytes, [Encoding encoding = Encoding.UTF_8]) {
  if (bytes.length == 0) return "";

  var string;
  var controller = new StreamController();
  controller.stream
    .transform(new StringDecoder(encoding))
    .listen((data) => string = data);
  controller.add(bytes);
  controller.close();
  return string;
}


/// Utility function to synchronously encode a String.
/// It will throw an exception if the encoding is invalid.
List<int> encodeString(String string, [Encoding encoding = Encoding.UTF_8]) {
  if (string.length == 0) return [];

  var bytes;
  var controller = new StreamController();
  controller.stream
    .transform(new StringEncoder(encoding))
    .listen((data) => bytes = data);
  controller.add(string);
  controller.close();
  return bytes;
}
