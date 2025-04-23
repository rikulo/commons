//Copyright (C) 2015 Potix Corporation. All Rights Reserved.
//History: Sat Jun 27 23:11:53 CST 2015
// Author: tomyeh
library rikulo_html;

import 'dart:js_interop';

import 'package:web/web.dart';

import "util.dart" show XmlUtil;

/// Set inner html with an empty tree sanitizer
void setUncheckedInnerHtml(Element element, String html, 
  {bool encode = false}) {
  
  if (encode) html = XmlUtil.encodeNS(html);
  
  element.setHTMLUnsafe(html.toJS);
}

/// Creates an element with an empty tree sanitizer.
Element createUncheckedHtml(String html, {bool encode = false}) {
  final template = HTMLTemplateElement();
  
  if (encode) html = XmlUtil.encodeNS(html);
  
  template.setHTMLUnsafe(html.toJS);
  final elem = template.content.firstElementChild;

  if (elem == null)
    throw 'Unsupported html: $html';

  return elem;
}