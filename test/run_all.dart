//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Apr 09, 2013  4:50:32 PM
// Author: tomyeh
library test_run_all;

import 'package:unittest/unittest.dart';

import 'async_test.dart' as async_test;
import 'inject_test.dart' as inject_test;
import 'convert_test.dart' as convert_test;
import 'io_test.dart' as io_test;
import 'util_test.dart' as util_test;
import 'http_test.dart' as http_test;
import 'browser_test.dart' as browser_test;

main() {
  group("async tests", async_test.main);
  group("io test", io_test.main);
  group("convert test", convert_test.main);
  group("util test", util_test.main);
  group("http test", http_test.main);
  group("inject tests", inject_test.main);
  group("browser tests", browser_test.main);
}
