//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:44:49 PM
// Author: tomyeh
part of rikulo_io;

/// Returns [ContentType] of the specified [path], or `null`
/// if not found.
///
/// For example,
///
///     getContentType("home.js");
///     getContentType("alpha/home.js");
///     getContentType("js");
///     getContentType("alpha/home.js?foo");
///       //returns ContentType.parse("text/javascript; charset=utf-8")
///
/// - [isExtension] whether [path] is an extension, e.g., "js".
/// If not specified (i.e., null), extension is assumed if
/// it doesn't contain '.' nor '/'.
/// - [autoUtf8] whether to append "; charset=utf-8" when detecting
/// a text mime type.
ContentType? getContentType(String? path,
    {List<int>? headerBytes, bool? isExtension, bool autoUtf8 = true}) {
  final mime = getMimeType(path, headerBytes: headerBytes,
      isExtension: isExtension, autoUtf8: autoUtf8);
  if (mime != null) return ContentType.parse(mime);
}

/** Returns an instance of [ContentType] of the given mime type,
 * such as `text/html; charset=utf-8`.
 *
 * Deprecated: use [ContentType.parse] directly.
 */
@Deprecated('Use ContentType.parse instead')
ContentType parseContentType(String value) => ContentType.parse(value);
