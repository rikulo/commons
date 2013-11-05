#Rikulo Commons Changes

##0.8.10

* contentTypes and httpStatusMessages are added.
* ObjectUtil.injectAsync() is removed since Dart removes asynchronous Mirrors API.

##0.8.2

* encodeString and decodeString are removed. Please use dart:convert directly.
* IOUtil is removed and replace with convert.dart.

##0.8.0

* defer() in async.dart was introduced to run a costly operation smartly.

##0.7.8

* gzip and gzipString were introduced.
* BufferedResponse renamed to StringBufferedResponse, while BufferedResponse reserved for bytes
* IOUtil.decode and IOUtil.encode became public methods: decodeString and encodeString.

##0.7.6

* The js package was removed (part of Rikulo Gap).

##0.7.4

* MapUtil.copy was introduced.
* The signature CssUtil.copy has been changed. To be consistent with others, the first argument is now the source.

##0.7.3

* Browser.size was removed. Use DomUtil.windowSize or window.innerWidth/innerHeight instead.

##0.7.2

* ClassUtil and ObjectUtil are both synchronous (no Future required)
* ClassUtil: renamed invokeObjectMirror to invokeByMirror; newInstanceByClassMirror to newInstanceByMirror

##0.7.1

* HttpUtil.decodePostedParameter was introduced to decode the parameters of a POST requests.

##0.7.0

* Css was renamed to CssUtil
* DomAgent was removed and replaced with DomUtil, which is a collection of static utilities.

##0.6.8

* encodeString and decodeString are put into IOUtil, and renamed to encode and decode
* IOUtil.readAsString and readAsJson are added.

##0.6.5

* StreamWrapper is added
* HttpRequestWrapper and HttpResponseWrapper are upgraded to new Dart API

##0.6.4

* ObjectUtil is added to inject values into the given object
* ClassUtil.coerce is added to coerce types

##0.6.3

* HttpHeadersWrapper is added.
* Upgrade to new Dart SDK.
* StreamProvider and CapturableStreamProvider are added.

##0.6.2

**Features**

* StringUtil, MapUtil and many others are added.
* HttpRequestWrapper and HttpRespnseWrapper are added.
