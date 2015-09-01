//Copyright (C) 2015 Potix Corporation. All Rights Reserved.
//History: Sat Jun 27 23:11:53 CST 2015
// Author: tomyeh
library rikulo_html;

import "dart:html";

import "util.dart" show XmlUtil;

///An allow-everyting [NodeValidator].
class NullNodeValidator implements NodeValidator {
  const NullNodeValidator();

  @override
  bool allowsElement(Element element) => true;
  @override
  bool allowsAttribute(Element element, String attributeName, String value) => true;
}

///An allow-everyting [NodeValidatorBuilder].
class NullNodeValidatorBuilder extends NullNodeValidator
    implements NodeValidatorBuilder {
  const NullNodeValidatorBuilder();

  @override
  void allowNavigation([UriPolicy uriPolicy]) {}
  @override
  void allowImages([UriPolicy uriPolicy]) {}
  @override
  void allowTextElements() {}
  @override
  void allowInlineStyles({String tagName}) {}
  @override
  void allowHtml5({UriPolicy uriPolicy}) {}
  @override
  void allowSvg() {}
  @override
  void allowCustomElement(String tagName,
      {UriPolicy uriPolicy,
      Iterable<String> attributes,
      Iterable<String> uriAttributes}) {}
  @override
  void allowTagExtension(String tagName, String baseName,
      {UriPolicy uriPolicy,
      Iterable<String> attributes,
      Iterable<String> uriAttributes}) {}
  @override
  void allowElement(String tagName, {UriPolicy uriPolicy,
    Iterable<String> attributes,
    Iterable<String> uriAttributes}) {}
  @override
  void allowTemplating() {}
  @override
  void add(NodeValidator validator) {}
}

/// Set inner html with an empty tree sanitizer
void setUncheckedInnerHtml(Element element, String html, 
  {bool encode: false}) {
  
  if (encode)
    html = XmlUtil.encode(html);
  
  element.setInnerHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
}

/// Creates an element with an empty tree sanitizer.
Element createUncheckedHtml(String html, {bool encode: false}) {
  
  if (encode)
    html = XmlUtil.encode(html);
  
  return new Element.html(html, treeSanitizer: NodeTreeSanitizer.trusted);
}
