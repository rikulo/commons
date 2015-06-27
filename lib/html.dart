//Copyright (C) 2015 Potix Corporation. All Rights Reserved.
//History: Sat Jun 27 23:11:53 CST 2015
// Author: tomyeh
library rikulo_html;

import "dart:html";

import "util.dart" show XmlUtil;

///An allow-anything [TreeSanitizer], i.e., it doesn't sanitize anything.
class NullTreeSanitizer implements NodeTreeSanitizer {
  const NullTreeSanitizer();
  void sanitizeTree(Node node) {}
}

///An allow-anyting [NodeValidator].
class NullNodeValidator implements NodeValidator {
  const NullNodeValidator();

  bool allowsElement(Element element) => true;
  bool allowsAttribute(Element element, String attributeName, String value) => true;
}

/// Set inner html with an empty tree sanitizer
void setUncheckedInnerHtml(Element element, String html, 
  {bool encode: false}) {
  
  if (encode)
    html = XmlUtil.encode(html);
  
  element.setInnerHtml(html, treeSanitizer: const NullTreeSanitizer());
}

/// Creates an element with an empty tree sanitizer.
Element createUncheckedHtml(String html, {bool encode: false}) {
  
  if (encode)
    html = XmlUtil.encode(html);
  
  return new Element.html(html, treeSanitizer: const NullTreeSanitizer());
}
