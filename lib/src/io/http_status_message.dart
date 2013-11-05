//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:54:03 PM
// Author: tomyeh
part of rikulo_io;

/** A map of HTTP status code to messages.
 *
 * For example,
 *
 *     print("httpStatusMessages[404]");
 */
Map<int, String> get httpStatusMessages {
  if (_httpstmsgs == null)
    _httpstmsgs = _initHttpStatusMessages();
  return _httpstmsgs;
}
Map<int, String> _httpstmsgs;

Map<int, String> _initHttpStatusMessages() {
  final Map<int, String> stmsgs = new HashMap();
  for (List inf in [
  //http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  [100, "Continue"],
  [101, "Switching Protocols"],
  [200, "OK"],
  [201, "Created"],
  [202, "Accepted"],
  [203, "Non-Authoritative Information"],
  [204, "No Content"],
  [205, "Reset Content"],
  [206, "Partial Content"],
  [300, "Multiple Choices"],
  [301, "Moved Permanently"],
  [302, "Found"],
  [303, "See Other"],
  [304, "Not Modified"],
  [305, "Use Proxy"],
  [307, "Temporary Redirect"],
  [400, "Bad Request"],
  [401, "Unauthorized"],
  [402, "Payment Required"],
  [403, "Forbidden"],
  [404, "Not found"],
  [405, "Method Not Allowed"],
  [406, "Not Acceptable"],
  [407, "Proxy Authentication Required"],
  [408, "Request Timeout"],
  [409, "Conflict"],
  [410, "Gone"],
  [411, "Length Required"],
  [412, "Precondition Failed"],
  [413, "Request Entity Too Large"],
  [414, "Request-URI Too Long"],
  [415, "Unsupported Media Type"],
  [416, "Requested Range Not Satisfiable"],
  [417, "Expectation Failed"],
  [500, "Internal Server Error"],
  [501, "Not Implemented"],
  [502, "Bad Gateway"],
  [503, "Service Unavailable"],
  [504, "Gateway Timeout"],
  [505, "HTTP Version Not Supported"]]) {
    stmsgs[inf[0]] = inf[1];
  }
  return stmsgs;
}
