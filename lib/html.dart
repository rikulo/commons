//Copyright (C) 2015 Potix Corporation. All Rights Reserved.
//History: Sat Jun 27 23:11:53 CST 2015
// Author: tomyeh
library rikulo_html;

import 'dart:js_interop';

import 'package:web/web.dart';

/// Sets [element]'s content from [html].
///
/// By default, sets `innerHTML` — the HTML is **not sanitized**, so
/// untrusted input is an XSS vector.
///
/// If [textContent] is true, sets `textContent` instead (treats [html]
/// as plain text).
void setRawInnerHtml(Element element, String html,
    {bool textContent = false}) {
  if (textContent) element.textContent = html;
  else element.innerHTML = html.toJS;
}

/// Parses [html] into a detached element via a `<template>`.
///
/// By default, the HTML is parsed — it is **not sanitized**; pass only
/// trusted markup. Untrusted input is an XSS vector.
///
/// If [textContent] is true, returns a `<span>` whose `textContent` is
/// [html] (treats [html] as plain text).
T createRawHtml<T extends Element>(String html,
    {bool textContent = false}) {
  if (textContent)
    return (HTMLSpanElement()..textContent = html) as T;

  final template = HTMLTemplateElement();
  template.innerHTML = html.toJS;

  final elem = template.content.firstElementChild;
  if (elem == null)
    throw UnsupportedError('No element from html: $html');

  return elem as T;
}

@Deprecated('Use setRawInnerHtml; pass `textContent: true` for safe text.')
void setUncheckedInnerHtml(Element element, String html, {bool encode = false})
=> setRawInnerHtml(element, html, textContent: encode);

@Deprecated('Use createRawHtml; pass `textContent: true` for safe text.')
T createUncheckedHtml<T extends Element>(String html, {bool encode = false})
=> createRawHtml<T>(html, textContent: encode);