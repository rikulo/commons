//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Apr 09, 2013  4:50:32 PM
// Author: tomyeh
library test_run_all;

import 'dart:io' show Options;
import 'package:unittest/compact_vm_config.dart';
import 'package:unittest/unittest.dart';

import 'inject_test.dart' as inject_test;
import 'io_test.dart' as io_test;
import 'util_test.dart' as util_test;
import 'http_test.dart' as http_test;
import 'tree_test.dart' as tree_test;

main() {
//  useCompactVMConfiguration();

  group("io test", io_test.main);
  group("util test", util_test.main);
  group("http test", http_test.main);
  group("inject tests", inject_test.main);
  group("tree tests", tree_test.main);
}
