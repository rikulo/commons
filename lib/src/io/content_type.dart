//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:44:49 PM
// Author: tomyeh
part of rikulo_io;

/// Returns [ContentType] of the specified [path], or null
/// if not fund.
///
/// For example,
///
///     getContentType("home.js");
///     getContentType("alpha/home.js");
///     getContentType("js");
///     getContentType("alpha/home.js?foo");
///       //returns parseContentType("text/javascript; charset=utf-8")''
///
/// - [isExtension] whether [path] is an extension, e.g., "js".
/// If not specified (i.e., null), extension is assumed if
/// it doesn't contain '.' nor '/'/
/// - [autoUtf8] whether to append "; charset=utf-8" when detecing
/// a text mime type.
ContentType? getContentType(String? path,
    {List<int>? headerBytes, bool? isExtension, bool autoUtf8: true}) {
  var mime = getMimeType(path, headerBytes: headerBytes,
      isExtension: isExtension, autoUtf8: autoUtf8);
  if (mime != null) return parseContentType(mime);
}

/**
 * Adds additional content type for the given extension.
 * Note: it overrides the system default if any.
 */
@Deprecated('Use getMimeType instead')
void addContentType(String extension, String mimeType)
=> addMimeType(extension, mimeType);

/** Returns an instance of [ContentType] of the given mime type,
 * such as `text/html; charset=utf-8`.
 *
 * For example,
 *
 *     response.headers.contentType =
 *       parseContentType('text/html; charset=utf-8');
 *
 * It is the same as [ContentType.parse], except it caches the result
 * to speed up the parsing.
 */
ContentType parseContentType(String value)
=> _rawCtypes[value] ?? (_rawCtypes[value] = ContentType.parse(value));

///value => ContentType
final _rawCtypes = HashMap<String, ContentType>();
