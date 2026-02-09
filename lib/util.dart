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

export "src/util/string_util.dart";

part "src/util/strings.dart";
part "src/util/xmls.dart";
part "src/util/lists.dart";
part "src/util/maps.dart";
part "src/util/color.dart";
part "src/util/pair.dart";
part "src/util/invokes.dart";
part "src/util/mime_type.dart";
part "src/util/regex.dart";

/** A function that returns an integer.
 */
typedef int AsInt();
/** A function that returns a double.
 */
typedef double AsDouble();
/** A function that returns a string.
 */
typedef String AsString();
/** A function that returns a bool.
 */
typedef bool AsBool();

/** A function that returns a map.
 */
typedef Map<K, V> AsMap<K, V>();
/** A function that returns a list.
 */
typedef List<T> AsList<T>();

/// Tests whether the status code is a successfully response.
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
  bool operator<(DateTime o) => this.isBefore(o);
  bool operator<=(DateTime o) => !this.isAfter(o);
  bool operator>(DateTime o) => this.isAfter(o);
  bool operator>=(DateTime o) => !this.isBefore(o);

  DateTime operator-(Duration diff) => this.subtract(diff);
  DateTime operator+(Duration diff) => this.add(diff);

  Duration operator | (DateTime o) => this.difference(o);
}
