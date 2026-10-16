//Copyright (C) 2026 Potix Corporation. All Rights Reserved.
//History: Fri Oct 16 2026
// Author: tomyeh
library test_ajax;

import "dart:io";
import 'package:test/test.dart';
import "package:rikulo_commons/io.dart";

/// [ajax]'s maxLength, against a local server whose body is `n` bytes
/// for the path `/n`, with `Content-Length` only if the query has `len`,
/// and gzip-compressed if it has `gzip`.
void main() {
  late HttpServer server;
  late Uri base;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    base = Uri.parse('http://127.0.0.1:${server.port}');
    server.listen((request) async {
      final n = int.parse(request.uri.path.substring(1)),
        resp = request.response,
        params = request.uri.queryParameters;
      if (params.containsKey('len'))
        resp.contentLength = n;
      if (params.containsKey('gzip')) { //a zip bomb: tiny on the wire
        resp.headers.set(HttpHeaders.contentEncodingHeader, 'gzip');
        resp.add(gzip.encode(List.filled(n, 0x61)));
        await resp.close();
        return;
      }
      for (var i = 0; i < n; i += 1000)
        resp.add(List.filled(n - i < 1000 ? n - i: 1000, 0x61));
      await resp.close();
    });
  });
  tearDownAll(() => server.close(force: true));

  test("within maxLength", () async {
    final resp = await ajax(base.resolve('/5000'), maxLength: 5000);
    expect(resp.bodyBytes.length, 5000);
    expect(resp.body.substring(0, 3), 'aaa');
  });

  test("over maxLength, chunked", () async {
    await expectLater(ajax(base.resolve('/5001'), maxLength: 5000),
        throwsA(isA<HttpException>()
          .having((e) => e.message, 'message', 'Response exceeds 5000 bytes')));
  });

  test("over maxLength, by Content-Length", () async {
    await expectLater(ajax(base.resolve('/9000?len'), maxLength: 5000),
        throwsA(isA<HttpException>()
          .having((e) => e.message, 'message', 'Content-Length exceeds 5000')));
  });

  test("a huge body stops early", () async {
    await expectLater(ajax(base.resolve('/50000000'), maxLength: 1000),
        throwsA(isA<HttpException>()));
  });

  test("a zip bomb is capped by the decompressed size", () async {
    await expectLater(ajax(base.resolve('/50000000?gzip'), maxLength: 1000),
        throwsA(isA<HttpException>()
          .having((e) => e.message, 'message', 'Response exceeds 1000 bytes')));
  });

  test("no maxLength", () async {
    final resp = await ajax(base.resolve('/20000'));
    expect(resp.bodyBytes.length, 20000);
  });
}
