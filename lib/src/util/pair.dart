//Copyright (C) 2021 Potix Corporation. All Rights Reserved.
//History: Wed Mar 31 22:20:14 CST 2021
// Author: tomyeh
part of rikulo_util;

/// Represents a pair of objects.
/// It is useful for implementing a function returning a pair of objects.
class Pair<F, S> {
  final F first;
  final S second;

  const Pair(this.first, this.second);
  Pair.fromJson(List json): this(json[0] as F, json[1] as S);

  S get last => second;

  List toJson() => [first, second];

  @override
  int get hashCode => Object.hash(first, second);
  @override
  bool operator==(o) => o is Pair && first == o.first && second == o.second;
  @override
  String toString() => toJson().toString();
}

/// Represents a tuple of objects.
/// It is useful for implementing a function returning a trio of objects.
class Trio<F, S, T> {
  final F first;
  final S second;
  final T third;

  const Trio(this.first, this.second, this.third);
  Trio.fromJson(List json): this(json[0] as F, json[1] as S, json[2] as T);

  T get last => third;

  List toJson() => [first, second, third];

  @override
  int get hashCode => Object.hash(first, second, third);
  @override
  bool operator==(o) => o is Trio && first == o.first
      && second == o.second && third == o.third;
  @override
  String toString() => toJson().toString();
}
