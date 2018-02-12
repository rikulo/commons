//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//Feb. 04, 2012
library rikulo_util;

//don't include dart:html since this library is designed to work
//at both client and server
import "dart:math" show max, min;
import "dart:collection";

part "src/util/strings.dart";
part "src/util/xmls.dart";
part "src/util/lists.dart";
part "src/util/maps.dart";
part "src/util/color.dart";

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
