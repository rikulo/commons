//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 19, 2013  5:33:00 PM
// Author: tomyeh
library test_inject;

import "package:rikulo_commons/mirrors.dart";

class User {
  User({this.firstName, lastName, this.manager}): _lastName = lastName;

  String firstName, _lastName;

  void set lastName(String name) {
    _lastName = name;
  }
  String get lastName => _lastName;

  int age;
  String toString() => "User($firstName $lastName, $age)";
  User manager;
}

void main() {
  ObjectUtil.inject(new User(), {
    "firstName": "Bill",
    "lastName": "Gates",
    "age": "32", //test coercion
    "manager.firstName": "John",
    "manager.lastName": "Kyle"
    }).then((user) {
      print("Done: $user, adult: ${user.age > 20}, manager: ${user.manager}");
    });;
}
