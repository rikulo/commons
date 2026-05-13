//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Jun 14, 2013  9:59:15 AM
// Author: tomyeh
library rikulo_logging;

import "dart:async" show Future;
import "package:logging/logging.dart";

/// A simple handler for [Logger.onRecord], printing each record to stdout.
///
/// Use it to configure your root logger:
///
///     Logger("myorg").onRecord.listen(simpleLoggerHandler);
///
/// Note: printing is deferred via `Future(...)`, so records may be lost
/// if the process crashes before the event loop drains.
void simpleLoggerHandler(LogRecord record) {
  //for better response time, do it async (since the onRecord stream is sync)
  Future(() {
    print([
      "${record.time}:${record.loggerName}:${record.sequenceNumber}",
      "${record.level}: ${record.message}",
      if (record.error != null) "Cause: ${record.error}",
      if (record.stackTrace != null) "${record.stackTrace}",
    ].join("\n"));
  });
}
