//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Feb. 04, 2012
library rikulo_util;

//don't include dart:html since this library is designed to work
//at both client and server
import "dart:async";
import "dart:math" show max, min;
import "dart:collection";

import "package:charcode/ascii.dart";
import "package:mime/mime.dart";

part "src/util/strings.dart";
part "src/util/xmls.dart";
part "src/util/lists.dart";
part "src/util/maps.dart";
part "src/util/color.dart";
part "src/util/pair.dart";
part "src/util/invokes.dart";
part "src/util/mime_type.dart";
part "src/util/regex.dart";

/// A function that returns an integer.
typedef AsInt = int Function();
/// A function that returns a double.
typedef AsDouble = double Function();
/// A function that returns a string.
typedef AsString = String Function();
/// A function that returns a bool.
typedef AsBool = bool Function();

/// A function that returns a map.
typedef AsMap<K, V> = Map<K, V> Function();
/// A function that returns a list.
typedef AsList<T> = List<T> Function();

/// Whether the HTTP [status] code is a successful response (2xx range).
/// Null, redirects (3xx), informational (1xx), and error codes return false.
///
/// For an `http.Response`, prefer `isResponseOK(resp)` (in `io.dart`).
bool isHttpStatusOK(int? status) => status != null && status >= 200 && status < 300;

///Parses the given list into a list of PODOs (plain-old-dart-object).
/// It returns null if [json] is null.
List<T>? convertList<T, S>(Iterable? json, T parse(S element))
=> json != null ? convertListNS(json, parse): null;

/// Parses the given list into a list of PODOs.
/// Unlike [convertList], it returns an empty list if [json] is null
List<T> convertListNS<T, S>(Iterable? json, T parse(S element)) {
  final result = <T>[];
  if (json != null)
    for (final each in json)
      result.add(parse(each as S));
  return result;
}

/// Extension for [DateTime] supporting `<`, `>` ...
///
/// If you don't like it, you can hide it from importing:
/// 
///     import "package:rikulo_commons/util.dart" hide DateTimeComparator
extension DateTimeComparator on DateTime {
  bool operator<(DateTime o) => isBefore(o);
  bool operator<=(DateTime o) => !isAfter(o);
  bool operator>(DateTime o) => isAfter(o);
  bool operator>=(DateTime o) => !isBefore(o);

  DateTime operator-(Duration diff) => subtract(diff);
  DateTime operator+(Duration diff) => add(diff);

  Duration operator | (DateTime o) => difference(o);
}
