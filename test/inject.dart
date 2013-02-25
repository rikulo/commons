//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 19, 2013  5:33:00 PM
// Author: tomyeh
library test_inject;

import 'package:/unittest/unittest.dart';
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
  test("inject one-level", () {
    ObjectUtil.inject(new User(), {
      "firstName": "Bill",
      "lastName": "Gates",
      "age": "32" //test coercion
      }).then((user) {
        expect(user.firstName, "Bill");
        expect(user.lastName, "Gates");
        expect(user.age, 32);
      });
    });
  test("inject two-level and auto-assign", () {
    ObjectUtil.inject(new User(), {
      "firstName": "Bill",
      "lastName": "Gates",
      "age": "32", //test coercion
      "manager.firstName": "John",
      "manager.lastName": "Kyle"
      }).then((user) {
        expect(user.firstName, "Bill");
        expect(user.lastName, "Gates");
        expect(user.age, 32);
        expect(user.manager, isNotNull);
        expect(user.manager.firstName, "John");
        expect(user.manager.lastName, "Kyle");
      });
    });
}
