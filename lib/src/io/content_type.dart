//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Nov 05, 2013  2:44:49 PM
// Author: tomyeh
part of rikulo_io;

/// Retrieves the mime type from the given [path] and, optional,
/// header bytes ([headerBytes]).
/// It returns null if not fund.
///
/// For example,
///
///     getMimeType("home.js");
///     getMimeType("alpha/home.js");
///     getMimeType("js");
///     getMimeType("alpha/home.js?foo");
///       //returns "text/javascript; charset=utf-8";
///
/// - [isExtension] whether [path] is an extension, e.g., "js".
/// If not specified (i.e., null), extension is assumed if
/// it doesn't contain '.' nor '/'/
/// - [autoUtf8] whether to append "; charset=utf-8" when detecing
/// a text mime type.
String? getMimeType(String? path,
    {List<int>? headerBytes, bool? isExtension, bool autoUtf8: true}) {
  if (path != null) {
    final i = path.lastIndexOf('?');
    if (i >= 0) path = path.substring(0, i);

    if (isExtension == null) isExtension = !_rePath.hasMatch(path);
    if (isExtension) path = '.$path';

    final mime = _mimeResolver.lookup(path, headerBytes: headerBytes);
    if (mime != null)
      return autoUtf8 && _isTextType(mime) ? "$mime; charset=utf-8": mime;
  }
}
final _rePath = RegExp(r'[./]');

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
 * Adds additonal content type for the given extension.
 * Note: it overrides the system default if any.
 * 
 * Example:
 * 
 *     addContentType("woff2", "application/font-woff2");
 */
void addContentType(String extension, String mimeType) {
  assert(!extension.startsWith('.'));
  assert(mimeType.isNotEmpty);
  _mimeResolver.addExtension(extension, mimeType);
}

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

bool _isTextType(String mime)
=> mime.startsWith("text/") || (mime.startsWith(_appPrefix)
  && (mime.endsWith('+xml') || mime.endsWith('+json')
    || _textSubtypes.contains(mime.substring(_appPrefix.length))));

const String _appPrefix = "application/";
const _textSubtypes = <String> {
  "json", "javascript", "dart", "xml",
};

final MimeTypeResolver _mimeResolver = (() {
  final resolver = MimeTypeResolver();
  _mimeMap.forEach(resolver.addExtension);
  return resolver;
}) ();

const _mimeMap = {
  "heic": "image/heic",
  "heif": "image/heif",

  //https://gist.github.com/hugoware/957656
  "323": "text/h323",
  "acx": "application/internet-property-stream",
  "asr": "video/x-ms-asf",
  "axs": "application/olescript",
  "bas": "text/plain",
  "fif": "application/fractals",
  "flr": "x-world/x-vrml",
  "gz": "application/x-gzip",
  "hta": "application/hta",
  "htc": "text/x-component",
  "htt": "text/webviewhtml",
  "iii": "application/x-iphone",
  "ins": "application/x-internet-signup",
  "isp": "application/x-internet-signup",
  "jfif": "image/pipeg",
  "lsf": "video/x-la-asf",
  "lsx": "video/x-la-asf",
  "mht": "message/rfc822",
  "mhtml": "message/rfc822",
  "mpa": "video/mpeg",
  "mpv2": "video/mpeg",
  "nws": "message/rfc822",
  "pko": "application/ynd.ms-pkipko",
  "pma": "application/x-perfmon",
  "pmc": "application/x-perfmon",
  "pmr": "application/x-perfmon",
  "pmw": "application/x-perfmon",
  "po": ",  application/vnd.ms-powerpoint",
  "sct": "text/scriptlet",
  "sst": "application/vnd.ms-pkicertstore",
  "stm": "text/html",
  "tgz": "application/x-compressed",
  "uls": "text/iuls",
  "webmanifest": "application/manifest+json",
  //"woff": "font/woff", //redundant
  "woff2": "font/woff2",
  "wrz": "x-world/x-vrml",
  "xaf": "x-world/x-vrml",
  "xof": "x-world/x-vrml",
  "z": "application/x-compress",

  //http://help.dottoro.com/lapuadlp.php
  "asp": "application/x-asp",
  "c++": "text/x-c++src",
  "cfc": "application/x-cfm",
  "cfm": "application/x-cfm",
  "cp": "text/x-c++src",
  "dib": "image/bmp",
  "diff": "text/x-patch",
  "dta": "application/x-stata",
  "dv": "video/x-dv",
  "enl": "application/x-endnote-library",
  "enz": "application/x-endnote-library",
  "fqd": "application/x-director",
  "indd": "application/x-indesign",
  "lib": "application/x-endnote-library",
  "llb": "application/x-labview",
  "lvx": "application/x-labview-exec",
  "m": "text/x-objcsrc",
  "m4a": "audio/m4a",
  "mail": "message/rfc822",
  "mfp": "application/x-shockwave-flash",
  "mqv": "video/quicktime",
  "mws": "application/x-maple",
  "one": "application/msonenote",
  "patch": "text/x-patch",
  "pcd": "image/x-photo-cd",
  "php": "application/x-php",
  "pict": "image/x-pict",
  "pjpeg": "image/jpeg",
  "pl": "application/x-perl",
  "pm": "application/x-perl",
  "pod": "text/x-pod",
  "py": "text/x-python",
  "rpm": "audio/vnd.rn-realaudio",
  "rv": "video/vnd.rn-realvideo",
  "sas": "application/sas",
  "sav": "application/spss",
  "sd2": "application/spss",
  "sea": "application/x-sea",
  "shtml": "text/html",
  "spo": "application/spss",
  "tnef": "application/ms-tnef",
  "twb": "application/twb",
  "twbx": "application/twb",
  "war": "application/x-webarchive",
  "xll": "application/vnd.ms-excel",
};

/// Validates and returns redundancy in mime additional map.
/// It is used only for debugging purpose.
List<String> validateContentTypes() {
  final redundancy = <String>[];
  for (final ext in _mimeMap.keys)
    if (lookupMimeType(".$ext") != null)
      redundancy.add(ext);
  return redundancy;
}
