# Rikulo Commons Changes

### 6.2.0

* `Browser.version` interpret "version/16.3" as `16.3` instead of `16.03`
* `Browser.parseVersion` supports the twoDigits version.

### 6.1.0

* `ReplaceAll` added

### 6.0.1

* `Pair.from()` and `Trio.from()` added

### 5.2.2

* `convertListNS` accepts a null list.

### 5.2.1

* `convertList` and `convertListNS` added.

### 5.2.0

* `isHttpStatusOK` accepts null.

### 5.1.0

* `getMimeType` added
* `getContentType` supports `headerBytes` and path
    * Also detect more mime types

### 5.0.6

* The constructors of HttpRequestWrapper, HttpResponseWrapper, HttpHeadersWrapper... accept `null` as `origin`.

### 5.0.5

* Merged changes of 4.6 into 5.0
* `encodeNS` and `decodeNS` introduced. They're null-safety version of `encode` and `decode`

### 4.6.1

* `defer()` replaces the key, so the invocation of `task` will be the last key.

### 4.6.0

* BREAK CHANGE: `configureDefers()`'s `executor` argument's signature is changed.
* BREAK CHANGE: `defer`'s `categoryKey` is renamed to `category`

### 4.5.0

* `configureDefers()` supports `executable` to slow down if the system is busy. 
* BREAK CHANGE: `name` is removed from `Browser`
* BREAK CHANGE: `onStatusCode` is removed from `ajax`

### 4.3.3

* `readAsJson`, `readAsString` and `HttpUtil.decodePostedParameters` support `maxLength`
* BREAK: `HttpUtil.decodePostedParameters` and `decodeQuery` use named parameters.

### 5.0.3

* `InvokeUtil.invokeSafely` added.
* `MapUtil.parse`'s `defaultValue` is an empty string.
* Rename `LIST_MIRROR` and other mirrored types as static members of `Mirror`

### 5.0.2

* `StreamUtil.first` added.

### 5.0.1

* `Pair` and `Trio` added.

### 5.0.0

* Migrate to Dart 2.12 (null safety)
* Clean up deprecated methods: `Browser.edge`, `Browser.name` and the `onStatusCode` argument of Ajax utilities.

### 4.3.2

* `InvokeUtil.invokeSafelyWith` added.

### 4.3.1

* `InvokeUtil.invokeSafely` added.
* `StreamUtil.first` added.
* `Pair` and `Trio` added.

### 4.3.0

* `Browser.legacyEdge` and `Browser.newEdge` are addded, and `Browser.name` and `Browser.edge` are deprecated.
* Also, we also consider `Browser.newEdge` and `Browser.legacyEdge` as a variant of Chrome, so `Browser.chrome` is also true in this case.

### 4.2.1

* `Browser.linux` and `Browser.windows` added

### 4.2.0

* `ajax`/`head`/`post`: The `onResponse` argument is supported, and the `onStatusCode` argument deprecated.

### 4.1.3

* The `maxBusy` setting was introduced to `configureDefers`.
* The following `defer()` will wait for the executing one to complete.

### 4.1.1

* Extension to support the comparators for `DateTime`, such as `<`, `>`, and `-`.

### 4.1.0

* Fix [#6](https://github.com/rikulo/commons/issues/6) The method 'HttpHeadersWrapper.set' has fewer named arguments than those of overridden method 'HttpHeaders.set'. [Dart 2.8]

### 4.0.1+1

* Limit Dart SDK version for Dart 2.8 version breaking change.
* add links to github repo in pubspec.yaml.

### 4.0.1

* Fix #5

### 4.0.0

* `defer()`'s `task` callback takes the key as the argument. It helps to reuse the same closure for different keys.

### 3.3.1

* `cancelDeferred()` added.

### 3.3.0

* Upgrade to Dart 2.5 or later

### 3.2.1+1

* Prepare for upcoming breaking changes to `HttpRequest` in the Dart SDK.

### 3.2.1

* `XmlUtil.encode()` supports the `entity` parameter to escape XML entities.

### 3.2.0

* `ajax()` added to simplify HTTP request at server side or flutter.

### 3.1.3

* The signature of flushDefers() was changed. Use `repeatLater: Duration.zero` instead of `repeat: true`.

### 3.1.0

* `Browser.dart` not supported.

### 3.0.0

* Dart 2 required

### 2.3.0

* The signature of flushDefers() was changed.

### 2.2.1

* flushDefers() introduced to flush all deferred tasks.

### 2.2.0

* Browser.version considers, say, `12.1` as a double, `12.01`. Thus, `12.10` is larger than `12.1`.

### 2.0.6

* NullTreeSanitizer is removed. Please use NodeTreeSanitizer.trusted instead which was introduced in Dart 1.12.

### 2.0.5

* NullTreeSanitizer, NullNodeValidator, setUncheckedInnerHtml and createUncheckedHtml are added.

### 2.0.3

* MapWrapper is introduced to simplify the extension of a map instance.

### 2.0.1

* XmlUtil.encode() supports the space argument to preserve the right space also able to break lines

### 2.0.0

* StringUtil's toHexString, addCharCodes, encodeId, filterIn and filterOut have been removed.
* MapUtil.onDemand has been renamed to MapUtil.auto
* The html library has been removed.

### 1.1.5

* addContentType() is introduced to add extra content types that the mime package might not support yet.
* TreeLink is removed.

### 1.1.4

* TreeLink is deprecated and will be removed soon.

### 1.0.3

* AbstractBufferedResponse is added.

### 1.0.1

* XmlUtil.encode() changed: multiline renamed to multiLine, and maxlength not supported.

### 1.0.0

*November 20, 2013*

* EMPTY_SET is added.

### 0.8.10

* contentTypes and httpStatusMessages are added.
* ObjectUtil.injectAsync() is removed since Dart removes asynchronous Mirrors API.

### 0.8.2

* encodeString and decodeString are removed. Please use dart:convert directly.
* IOUtil is removed and replace with convert.dart.

### 0.8.0

* defer() in async.dart was introduced to run a costly operation smartly.

### 0.7.8

* gzip and gzipString were introduced.
* BufferedResponse renamed to StringBufferedResponse, while BufferedResponse reserved for bytes
* IOUtil.decode and IOUtil.encode became public methods: decodeString and encodeString.

### 0.7.6

* The js package was removed (part of Rikulo Gap).

### 0.7.4

* MapUtil.copy was introduced.
* The signature CssUtil.copy has been changed. To be consistent with others, the first argument is now the source.

### 0.7.3

* Browser.size was removed. Use DomUtil.windowSize or window.innerWidth/innerHeight instead.

### 0.7.2

* ClassUtil and ObjectUtil are both synchronous (no Future required)
* ClassUtil: renamed invokeObjectMirror to invokeByMirror; newInstanceByClassMirror to newInstanceByMirror

### 0.7.1

* HttpUtil.decodePostedParameter was introduced to decode the parameters of a POST requests.

### 0.7.0

* Css was renamed to CssUtil
* DomAgent was removed and replaced with DomUtil, which is a collection of static utilities.

### 0.6.8

* encodeString and decodeString are put into IOUtil, and renamed to encode and decode
* IOUtil.readAsString and readAsJson are added.

### 0.6.5

* StreamWrapper is added
* HttpRequestWrapper and HttpResponseWrapper are upgraded to new Dart API

### 0.6.4

* ObjectUtil is added to inject values into the given object
* ClassUtil.coerce is added to coerce types

### 0.6.3

* HttpHeadersWrapper is added.
* Upgrade to new Dart SDK.
* StreamProvider and CapturableStreamProvider are added.

### 0.6.2

**Features**

* StringUtil, MapUtil and many others are added.
* HttpRequestWrapper and HttpRespnseWrapper are added.
