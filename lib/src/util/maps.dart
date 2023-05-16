//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Thu, Jun 28, 2012 10:30:47 AM
// Author: tomyeh
part of rikulo_util;

/**
 * A collection of Map related utilities.
 */
class MapUtil {
  /** Returns a map that will be created only when necessary, such as
   * [Map.putIfAbsent] is called.
   *
   * It assumes the map was empty, and creates by invoking [creator]
   * when necessary. Don't use this method if the map already exists.
   *
   * It is useful to save the memory, if you have a map that won't contain
   * anything in most case.
   *
   * Notice you don't have to keep the object being returned by this method,
   * since it is just a proxy to the real map.
   * Refer to Rikulo UI's `View.dataset` for a sample implementation.
   */
  static Map<K, V> auto<K, V>(Map<K, V> creator()) => _OnDemandMap(creator);

  /** Copies the given map ([source]) to the destination ([dest]).
   */
  static Map<K, V?> copy<K, V>(Map<K, V?> source, Map<K, V?> dest,
      [bool filter(K key, V? value)?]) {
    for (final key in source.keys) {
      final value = source[key];
      if (filter != null && filter(key, value))
        dest[key] = value;
    }
    return dest;
  }

  /** Parses the given string into a map.
   * The format of data is the same as HTML: `=` is optional, and
   * the value must be enclosed with `'` or `"`.
   *
   * * [backslash] specifies whether to handle backslash, such \n and \\.
   * * [defaultValue] specifies the value to use if it is not specified
   * (i.e., no equal sign).
   */
  static Map<String, String> parse(String data,
      {bool backslash = true, String defaultValue = ""}) {
    final map = LinkedHashMap<String, String>();
    for (int i = 0, len = data.length; i < len;) {
      i = StringUtil.skipWhitespaces(data, i);
      if (i >= len)
        break; //no more

      final j = i;
      for (; i < len; ++i) {
        final cc = data.codeUnitAt(i);
        if (cc == $equal || $whitespaces.contains(cc))
          break;
        if (cc == $single_quote || cc == $double_quote)
          throw FormatException("Quotation marks not allowed in key, $data");
      }

      final key = data.substring(j, i);
      if (key.isEmpty)
        throw FormatException("Key required, $data");

      i = StringUtil.skipWhitespaces(data, i);
      if (i >= len || data.codeUnitAt(i) != $equal) {
        map[key] = defaultValue;
        if (i >= len)
          break; //done
        continue;
      }

      final val = StringBuffer();
      i = StringUtil.skipWhitespaces(data, i + 1);
      if (i < len) {
        final sep = data.codeUnitAt(i);
        if (sep != $double_quote &&  sep != $single_quote)
          throw FormatException("Quatation marks required for a value, $data");

        for (;;) {
          if (++i >= len)
            throw FormatException("Unclosed string, $data");

          final cc = data.codeUnitAt(i);
          if (cc == sep) {
            ++i;
            break; //done
          }
          if (backslash && cc == $backslash) {
            if (++i >= len)
              throw FormatException("Illegal backslash, $data");
            switch (data.codeUnitAt(i)) {
              case $n: val.write('\n'); continue;
              case $t: val.write('\t'); continue;
              case $b: val.write('\b'); continue;
              case $r: val.write('\r'); continue;
              default: val.writeCharCode(data.codeUnitAt(i)); continue;
            }
          }
          val.writeCharCode(cc);
        }
      } //if i >= 0
      map[key] = val.toString();
    }
    return map; 
  }
}

/** A map wrapper for proxying another map.
 */
class MapWrapper<K, V> implements Map<K,V> {
  final Map<K, V> origin;

  MapWrapper(Map<K, V> this.origin);

  @override
  V? operator[](Object? key) => origin[key];
  @override
  void operator[]=(K key, V value) {
    origin[key] = value;
  }
  @override
  void addAll(Map<K, V> other) {
    origin.addAll(other);
  }
  @override
  void clear() {
    origin.clear();
  }
  @override
  bool containsKey(Object? key) => origin.containsKey(key);
  @override
  bool containsValue(Object? value) => origin.containsValue(value);
  @override
  void forEach(void f(K key, V value)) {
    origin.forEach(f);
  }
  @override
  Iterable<K> get keys => origin.keys;
  @override
  Iterable<V> get values => origin.values;
  @override
  bool get isEmpty => origin.isEmpty;
  @override
  bool get isNotEmpty => origin.isNotEmpty;
  @override
  int get length => origin.length;
  @override
  V putIfAbsent(K key, V ifAbsent()) => origin.putIfAbsent(key, ifAbsent);
  @override
  V? remove(Object? key) => origin.remove(key);

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries)
  => origin.addEntries(newEntries);
  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> f(K key, V value)) => origin.map(f);
  @override
  Map<RK, RV> cast<RK, RV>() => origin.cast();
  @override
  void removeWhere(bool predicate(K key, V value))
  => origin.removeWhere(predicate);
  @override
  V update(K key, V update(V value), {V ifAbsent()?})
  => origin.update(key, update, ifAbsent: ifAbsent);
  @override
  void updateAll(V update(K key, V value)) => origin.updateAll(update);
  @override
  Iterable<MapEntry<K, V>> get entries => origin.entries;

  @override
  String toString() => origin.toString();
  @override
  bool operator==(Object o) => o is MapWrapper && o.origin == origin;
  @override
  int get hashCode => origin.hashCode;
}

class _OnDemandMap<K, V> implements Map<K,V> {
  final AsMap<K, V> _creator;
  Map<K, V>? _map;

  _OnDemandMap(AsMap<K, V> this._creator);

  Map<K, V> _init() => _map ?? (_map = _creator());

  @override
  V? operator[](Object? key) => _map?[key];
  @override
  void operator[]=(K key, V value) {
    _init()[key] = value;
  }
  @override
  void addAll(Map<K, V> other) {
    if (other.isNotEmpty) _init().addAll(other);
  }
  @override
  void clear() {
    _map?.clear();
  }
  @override
  bool containsKey(Object? key) => _map?.containsKey(key) ?? false;
  @override
  bool containsValue(Object? value) => _map?.containsValue(value) ?? false;
  @override
  void forEach(void f(K key, V value)) {
    _map?.forEach(f);
  }
  @override
  Iterable<K> get keys => _map?.keys ?? const [];
  @override
  Iterable<V> get values => _map?.values ?? const [];
  @override
  bool get isEmpty => _map?.isEmpty ?? true;
  @override
  bool get isNotEmpty => !isEmpty;
  @override
  int get length => _map?.length ?? 0;
  @override
  V putIfAbsent(K key, V ifAbsent()) => _init().putIfAbsent(key, ifAbsent);
  @override
  V? remove(Object? key) => _map?.remove(key);
  @override
  String toString() => (_map ?? const {}).toString();

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    if (newEntries.isNotEmpty) _init().addEntries(newEntries);
  }
  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> f(K key, V value))
  => _map?.map(f) ?? {};
  @override
  Map<RK, RV> cast<RK, RV>() => _init().cast();
  @override
  void removeWhere(bool predicate(K key, V value)) {
    _map?.removeWhere(predicate);
  }
  @override
  V update(K key, V update(V value), {V ifAbsent()?})
  => _init().update(key, update, ifAbsent: ifAbsent);
  @override
  void updateAll(V update(K key, V value)) {
    _map?.updateAll(update);
  }
  @override
  Iterable<MapEntry<K, V>> get entries => _init().entries;
}
