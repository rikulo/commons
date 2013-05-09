//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, May 01, 2013  7:49:08 PM
// Author: tomyeh
library test_tree;

import 'package:unittest/unittest.dart';
import "package:rikulo_commons/util.dart";

class _MyTreeLink extends TreeLink<Node> {
  _MyTreeLink(Node owner): super(owner);

  TreeLink getLink_(Node node) => node._link;
}

class Node {
  String data;
  _MyTreeLink _link;

  Node(this.data) {
    _link = new _MyTreeLink(this);
  }

  Node get parent => _link.parent;
  Node get firstChild => _link.firstChild;
  Node get lastChild => _link.lastChild;
  Node get nextSibling => _link.nextSibling;
  Node get previousSibling => _link.previousSibling;
  List<Node> get children => _link.children;

  bool addChild(Node node) => _link.addChild(node);
  bool removeChild(Node node) => _link.removeChild(node);
  bool remove() => _link.remove();
}

void main() {
  test("TreeLink", () {
    final root = new Node("root");
    for (int i = 0; i < 10; ++i) {
      final gp = new Node("$i");
      root.addChild(gp);
      for (int j = 0; j < 10; ++j) {
        final p = new Node("$i,$j");
        gp.addChild(p);
        for (int k = 0; k < 10; ++k) {
          p.addChild(new Node("$i,$j,$k"));
        }
      }
    }

    expect(root.children.length, 10);
    int i = 0;
    Iterator<Node> it = root.children.iterator;
    for (Node n = root.firstChild; n != null; n = n.nextSibling, ++i) {
      expect(n, root.children[i]);
      expect(n, (it..moveNext()).current);
    }

    var n1 = root.firstChild;
    var n3 = n1.children[3]..remove();
    n1.removeChild(n1.lastChild);
    var n2 = n1.children.removeAt(6);
    expect(n1.children.length, 7);
    expect(n1.children[3].data, "0,4");
    expect(n1.children[6].data, "0,8");
    expect(n1.children[6].nextSibling, isNull);
    expect(n2.parent, isNull);
    n1.children[6] = n2;
    expect(n1.children[6].data, "0,7");
    expect(n2.parent, n1);
    n1.children.insert(6, n3);
    expect(n1.children.length, 8);
    expect(n1.children[6], n3);
    expect(n1.children[6].nextSibling, n2);
    n1.children.remove(n3);
    expect(n1.children.length, 7);
    expect(n1.lastChild.data, "0,7");

    expect(root.children[2].children[5].children[8].data, "2,5,8");
  });
}