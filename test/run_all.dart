//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Apr 09, 2013  4:50:32 PM
// Author: tomyeh
library test_run_all;

import 'dart:io' show Options;
import 'package:unittest/compact_vm_config.dart';
import 'package:unittest/unittest.dart';

import 'inject_test.dart' as inject_test;
import 'io_test.dart' as io_test;
import 'http_test.dart' as http_test;

main() {
  useCompactVMConfiguration();

  io_test.main();
  http_test.main();
  inject_test.main();
}
