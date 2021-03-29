//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 19, 2013  5:33:00 PM
// Author: tomyeh
library test_inject;

import 'dart:mirrors';
import 'package:test/test.dart';
import "package:rikulo_commons/mirrors.dart";

class User {
  User({this.firstName, String lastName, this.manager}): _lastName = lastName;

  String firstName, _lastName;

  void set lastName(String name) {
    _lastName = name;
  }
  String get lastName => _lastName;

  int age;
  @override
  String toString() => "User($firstName $lastName, $age)";
  User manager;

  void set wrong(bool wrong) => throw "not callable";
  User get getterOnly => null;
  User get wrongUser => null;
  void set wrongUser(User user) => throw "not callable";
}

@deprecated
void main() {
  test("Class.forName", () {
    expect(INT_MIRROR, isNotNull);
    expect(NUM_MIRROR, isNotNull);
    expect(BOOL_MIRROR, ClassUtil.forName("dart.core.bool"));
    expect(reflect(User()).type, ClassUtil.forName("test_inject.User"));
  });

  group("inject tests", () {
    test("inject one-level", () {
      User user = ObjectUtil.inject(User(), {
        "firstName": "Bill",
        "lastName": "Gates",
        "age": "32" //test coercion
      }) as User;

      expect(user.firstName, "Bill");
      expect(user.lastName, "Gates");
      expect(user.age, 32);
    });

    test("inject three-level and auto-assign", () {
      User user = ObjectUtil.inject(User(), {
        "firstName": "Bill",
        "lastName": "Gates",
        "age": "32", //test coercion
        "manager.firstName": "John",
        "manager.lastName": "Kyle",
        "manager.manager.firstName": "Boss"
      }) as User;

      expect(user.firstName, "Bill");
      expect(user.lastName, "Gates");
      expect(user.age, 32);
      expect(user.manager, isNotNull);
      expect(user.manager.firstName, "John");
      expect(user.manager.lastName, "Kyle");
      expect(user.manager.manager.firstName, "Boss");
    });

    test("inject non-existing", () {
      User user = ObjectUtil.inject(User(), {
        "firstName": "Bill",
        "nonExisting": "Gates",
        "level1.level2": 123,
        "age": "32" //test coercion
      }, silent: true) as User;

      expect(user.firstName, "Bill");
      expect(user.lastName, isNull);
      expect(user.age, 32);
    });

    test("inject validate and onSetterError", () {
      List<String> validated = [];
      List<String> setterFailed = [];
      User user = ObjectUtil.inject(User(), {
        "firstName": "Bill",
        "lastName": "Gates",
        "age": "32", //test coercion
        "notFound": false,
        "wrong": true,
      }, validate: (obj, field, value) {
        validated.add(field);
      }, onSetterError: (obj, field, value, error) {
        setterFailed.add(field);
      }, silent: true) as User;

      expect(user.firstName, "Bill");
      expect(user.lastName, "Gates");
      expect(user.age, 32);
      expect(validated, ["firstName", "lastName", "age", "wrong"]);
      expect(setterFailed, ["wrong"]);
    });

    /*
    test("inject two-level and onSetterError", () {
      List<String> setterFailed = [];
      User user = ObjectUtil.inject(User(), {
        "manager.wrong": false,
        "whatever": 123,
        "manager.firstName": "John",
        "manager.firstName.notFound": true,
        "getterOnly.firstName": "Impossible",
        "wrongUser.lastName": "Oops"
      }, onSetterError: (obj, field, value, error) {
        setterFailed.add(field);
      });

      expect(user.manager.firstName, "John");
      expect(setterFailed, ["wrong", "whatever", "notFound", "getterOnly", "wrongUser"]);
    });*/
  }); //group
}
