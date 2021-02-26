//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:44:49 PM
// Author: tomyeh
part of rikulo_io;

/**
 * Returns [ContentType] of the specified extension, or null
 * if not fund.
 *
 * For example,
 *
 *     getContentType("js");
 *       //returns ContentType.parse("text/javascript; charset=utf-8")''
 *
 * Notice: as shown, if the format is text (such as `"text/plain"` and `"text/css"`),
 * the encoding is default to UTF8 (i.e., `charset=utf-8` will be appended).
 */
ContentType? getContentType(String extension) {
  assert(!extension.startsWith('.'));
  ContentType? ctype = _ctypes[extension];
  if (ctype != null)
    return ctype;

  String? mime = lookupMimeType(".$extension");
  if (mime == null)
    return null;

  if (_isTextType(mime))
    mime = "$mime; charset=utf-8";
  return _ctypes[extension] = _rawCtypes[mime] = ContentType.parse(mime);
}

/**
 * Adds additonal content type for the given extension.
 * Note: it overrides the system default if any.
 * 
 * Example:
 * 
 *     addContentType("woff2", "application/font-woff2");
 */
void addContentType(String extension, String contentType) {
  assert(!extension.startsWith('.'));
  assert(contentType.isNotEmpty);
  _ctypes[extension] = parseContentType(contentType);
}

/** Returns an instance of [ContentType] of the given value,
 * such as `text/html; charset=utf-8`.
 *
 * For example,
 *
 *     response.headers.contentType =
 *       parseContentType('text/html; charset=utf-8');
 *
 * It is the same as [ContentType.parse], except it will look for [ContentType]
 * from those cached by [getContentType].
 * If not found, forward to [ContentType.parse].
 * Thus, the performance is little better.
 */
ContentType parseContentType(String value) {
  final ContentType? ctype = _rawCtypes[value];
  return ctype != null ? ctype: ContentType.parse(value);
}

///extension => ContentType
final _ctypes = HashMap<String, ContentType>();
///value => ContentType
final _rawCtypes = HashMap<String?, ContentType>();

bool _isTextType(String mime)
=> mime.startsWith("text/")
|| (mime.startsWith(_appPrefix) &&
    _textSubtypes.containsKey(mime.substring(_appPrefix.length)));

const String _appPrefix = "application/";
const _textSubtypes = <String, bool> {
  "json": true, "javascript": true, "dart": true, "xml": true,
  "xhtml+xml": true, "xslt+xml": true,  "rss+xml": true,
  "atom+xml": true, "mathml+xml": true, "svg+xml": true
};

