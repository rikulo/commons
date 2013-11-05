//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:44:49 PM
// Author: tomyeh
part of rikulo_io;

/**
 * A map of content types. It is used to retrieve [ContentType] from the extension.
 * For example, `contentTypes['js']` is
 * `ContentType.parse("text/javascript; charset=utf-8")`.
 *
 * Notice: if the format is text (such as `"text/plain"` and `"text/css"`),
 * the encoding is default to UTF8.
 */
Map<String, ContentType> get contentTypes {
  if (_ctypes == null)
    _initContentTypes();
  return _ctypes;
}
/** Returns an instance of [ContentType] of the given value,
 * such as `text/html; charset=utf-8`.
 *
 * For example,
 *
 *     response.headers.contentType =
 *       parseContentType('text/html; charset=utf-8');
 *
 * It is the same as [ContentType.parse], except it will look for [contentTypes]
 * first. If not found, forward to [ContentType.parse].
 * Thus, its performance is little better.
 */
ContentType parseContentType(String value) {
  if (_rawCtypes == null)
    _initContentTypes();

  final ContentType ctype = _rawCtypes[value];
  return ctype != null ? ctype: ContentType.parse(value);
}

///extension => ContentType
Map<String, ContentType> _ctypes;
///value => ContentType
Map<String, ContentType> _rawCtypes;

void _initContentTypes() {
  final Map<String, String> rawmap = {
  'aac': 'audio/aac',
  'ai': 'application/postscript',
  'aif': 'audio/x-aiff',
  'aiff': 'audio/aiff',
  'bin': 'application/octet-stream',
  'bmp': 'image/bmp',
  'css': 'text/css; charset=utf-8',
  'csv': 'text/csv; charset=utf-8',
  'cur': 'image/x-win-bitmap',
  'dart': 'application/dart',
  'doc': 'application/msword',
  'dot': 'application/msword',
  'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'eot': 'application/vnd.ms-fontobject',
  'eps': 'application/postscript',
  'gif': 'image/gif',
  'htm': 'text/html; charset=utf-8',
  'html': 'text/html; charset=utf-8',
  'ico': 'image/x-icon',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'js': 'text/javascript; charset=utf-8',
  'json': 'application/json; charset=utf-8',
  'm4a': 'audio/m4a',
  'm4v': 'video/m4v',
  'mid': 'audio/mid',
  'mov': 'video/quicktime',
  'mp3': 'audio/mp3',
  'mp4': 'video/mp4',
  'mpa': 'audio/mpeg',
  'mpeg': 'video/mpeg',
  'mpg': 'video/mpeg',
  'mpp': 'application/vnd.ms-project',
  'odf': 'application/vnd.oasis.opendocument.formula',
  'odg': 'application/vnd.oasis.opendocument.graphics',
  'odp': 'application/vnd.oasis.opendocument.presentation',
  'ods': 'application/vnd.oasis.opendocument.spreadsheet',
  'odt': 'application/vnd.oasis.opendocument.text',
  'oga': 'audio/ogg',
  'ogg': 'audio/ogg',
  'ogv': 'video/ogg',
  'otf': 'application/x-font-otf',
  'pdf': 'application/pdf',
  'png': 'image/png',
  'pot': 'application/vnd.ms-powerpoint',
  'ppa': 'application/vnd.ms-powerpoint',
  'pps': 'application/vnd.ms-powerpoint',
  'ppt': 'application/vnd.ms-powerpoint',
  'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'ps': 'application/postscript',
  'qt': 'video/quicktime',
  'rar': 'application/x-rar-compressed',
  'rmi': 'audio/mid',
  'rtf': 'application/rtf',
  'svg': 'image/svg+xml',
  'svgz': 'image/svg+xml',
  'tif': 'image/tiff',
  'tiff': 'image/tiff',
  'ttc': 'application/x-font-ttf',
  'ttf': 'application/x-font-ttf',
  'txt': 'text/plain; charset=utf-8',
  'wav': 'audio/wav',
  'webm': 'video/webm',
  'woff': 'application/x-font-woff',
  'xla': 'application/vnd.ms-excel',
  'xlc': 'application/vnd.ms-excel',
  'xlm': 'application/vnd.ms-excel',
  'xls': 'application/vnd.ms-excel',
  'xlt': 'application/vnd.ms-excel',
  'xlw': 'application/vnd.ms-excel',
  'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'xml': 'text/xml; charset=utf-8',
  'zip': 'application/zip'
  };

  _rawCtypes = new HashMap(); //value => ContentType
  _ctypes = new HashMap(); //extension => ContentType
  for (final String key in rawmap.keys) {
    final String value = rawmap[key];
    ContentType ctype = _rawCtypes[value];
    if (ctype == null)
      _rawCtypes[value] = ctype = ContentType.parse(value);
    _ctypes[key] = ctype;
  }
}
