//Copyright (TreeLink) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, May 01, 2013  4:36:33 PM
// Author: tomyeh
part of rikulo_util;

typedef TreeLink _GetLink(node);

/**
 * Used for implementing a tree object with linked children.
 *
 * + `TreeLink` - the type of each node. For example,
 *
 *     class Node {
 *       TreeLink<Node> _link;
 *
 *        Node(this.data) {
 *         _link = new TreeLink(this, (node) => node._link);
 *       }
 *     }
 *
 * Please refer to [this example](https://github.com/rikulo/commons/blob/master/test/tree_test.dart).
 */
class TreeLink<T> {
  final T _owner;
  final _GetLink _getLink;
  TreeLink _parent;
  TreeLink _nextLink, _prevLink;
  _ChildInfo<T> _childInfo;

  TreeLink(T owner, TreeLink getLink(T node)): _owner = owner, _getLink = getLink;

  /** Returns if the given object is a descendant of this object or
   * it is identical to this object.
   */
  bool isDescendantOf(T parent) {
    final p = _getLink(parent);
    for (var w = this; w != null; w = w._parent) {
      if (identical(w, p))
        return true;
    }
    return false;
  }

  TreeLink get _firstLink => _childInfo != null ? _childInfo.firstLink: null;
  TreeLink get _lastLink => _childInfo != null ? _childInfo.lastLink: null;

  /** Returns the parent, or null if not parent.
   */
  T get parent => _getOwner(_parent);
  /** Returns the first child, or null if this object has no child at all.
   */
  T get firstChild => _childInfo != null ? _getOwner(_childInfo.firstLink): null;
  /** Returns the last child, or null if this object has no child at all.
   */
  T get lastChild => _childInfo != null ? _getOwner(_childInfo.lastLink): null;
  /** Returns the next sibling, or null if this object is the last sibling.
   */
  T get nextSibling => _getOwner(_nextLink);
  /** Returns the previous sibling, or null if this object is the first sibling.
   */
  T get previousSibling => _getOwner(_prevLink);

  /** Returns a list of child objects.
   */
  List<T> get children {
    final ci = _initChildInfo();
    if (ci.children == null)
      ci.children = new _Children(this);
    return ci.children;
  }
  /** Returns the number of child objects.
   */
  int get childCount => _childInfo != null ? _childInfo.nChild: 0;

  _ChildInfo _initChildInfo() {
    if (_childInfo == null)
      _childInfo = new _ChildInfo();
    return _childInfo;
  }

  /** Adds a child object.
   * If [beforeChild] is specified, the child will be inserted before it.
   * Otherwise, it will be added to the end.
   *
   * To remove a child from its parent, you can invoke [removeChild] or [remove],
   * such as `parent.removeChild(child)` or child.remove()`.
   *
   * It return false if nothing is changed, i.e., the given child is already at
   * the right position.
   */
  bool addChild(T child, [T beforeChild]) {
    if (isDescendantOf(child))
      throw new ArgumentError("$child is an ancestor of $_owner");

    final link = _getLink(child);
    TreeLink beforeLink;
    if (beforeChild != null) {
      beforeLink = _getLink(beforeChild);
      if (!identical(beforeLink._parent, this))
        beforeLink = null;
      else if (identical(link, beforeLink))
        return false; //nothing to change
    }

    final oldParent = link._parent;
    if (identical(oldParent, this) && identical(beforeLink, link._nextLink))
      return false; //nothing to change

    if (oldParent != null)
      _unlink(oldParent, link);
    _link(this, link, beforeLink);
    return true;
  }
  /** Removes this object from its parent and, if attached, from the document.
   *
   * If it has a parent, it will be detached from the parent.
   * Otherwise, nothing happens.
   *
   * It returns false if it doesn't belong to any parent
   */
  bool remove() => _parent != null && _parent._removeLink(this);

  /** Removes the given child.
   * Return true if [child] has been removed successfull.
   * Return false if [child] is not a child.
   */
  bool removeChild(T child) => child != null && _removeLink(_getLink(child));
  bool _removeLink(TreeLink link) {
    if (identical(link._parent, this)) {
      _unlink(this, link);
      return true;
    }
    return false;
  }
}

_getOwner(TreeLink link) => link != null ? link._owner: null;

void _link(TreeLink parent, TreeLink child, TreeLink beforeLink) {
  final _ChildInfo ci = parent._initChildInfo();
  if (beforeLink == null) {
    final p = ci.lastLink;
    if (p != null) {
      p._nextLink = child;
      child._prevLink = p;
      ci.lastLink = child;
    } else {
      ci.firstLink = ci.lastLink = child;
    }
  } else {
    final p = beforeLink._prevLink;
    if (p != null) {
      child._prevLink = p;
      p._nextLink = child;
    } else {
      ci.firstLink = child;
    }

    beforeLink._prevLink = child;
    child._nextLink = beforeLink;
  }
  child._parent = parent;

  ++parent._childInfo.nChild;
}
void _unlink(TreeLink parent, TreeLink child) {
  var p = child._prevLink, n = child._nextLink;
  if (p != null) p._nextLink = n;
  else parent._childInfo.firstLink = n;
  if (n != null) n._prevLink = p;
  else parent._childInfo.lastLink = p;
  child._nextLink = child._prevLink = child._parent = null;

  --parent._childInfo.nChild;
}

/** The children information used in [TreeLink].
 */
class _ChildInfo<T> {
  TreeLink firstLink, lastLink;
  int nChild = 0;
  List<T> children;
}

class _ChildrenIter<T> implements Iterator<T> {
  final TreeLink _first;
  TreeLink _curr;
  bool _moved = false;

  _ChildrenIter(this._first);

  @override
  T get current => _getOwner(_curr);
  @override
  bool moveNext() {
    if (!_moved) {
      _moved = true;
      _curr = _first;
    } else if (_curr != null) {
      _curr = _curr._nextLink;
    }
    return _curr != null;
  }
}
/**
 * A list of child objects.
 * Notice that [set length] are not supported
 */
class _Children<T> extends IterableBase<T> with ListMixin<T> implements List<T> {
  final TreeLink _owner;

  _Children(this._owner);

  TreeLink _getLink(T owner) => _owner._getLink(owner);

  @override
  int get length => _owner.childCount;
  @override
  Iterator<T> get iterator => new _ChildrenIter(_owner._firstLink);
  @override
  T get first {
    if (isEmpty)
      throw new StateError("No elements");
    return _owner.firstChild;
  }
  @override
  T get last {
    if (isEmpty)
      throw new StateError("No elements");
    return _owner.lastChild;
  }
  
  @override
  T operator[](int index) => _at(index)._owner;
  TreeLink _at(int index) {
    if (index < 0 || index > length)
      throw new RangeError.value(index);

    int index2 = length - index - 1;
    if (index <= index2) {
      TreeLink link = _owner._firstLink;
      while (--index >= 0)
        link = link._nextLink;
      return link;
    } else {
      TreeLink link = _owner._lastLink;
      while (--index2 >= 0)
        link = link._prevLink;
      return link;
    }
  }
  @override
  T elementAt(int index) => this[index];
  @override
  void operator[]=(int index, T value) {
    if (value == null)
      throw new ArgumentError();

    final TreeLink target = _at(index);
    if (!identical(target, _getLink(value))) {
      final TreeLink next = target._nextLink;
      _owner._removeLink(target);
      _owner.addChild(value, _getOwner(next));
    }
  }
  @override
  void add(T child) {
    _owner.addChild(child);
  }
  @override
  void sort([Comparator<T> compare]) {
    List<T> copy = new List.from(this);
    copy.sort(compare);
    setRange(0, length, copy);
  }
  @override
  T removeLast() {
    final TreeLink link = _owner._lastLink;
    if (link != null)
      _owner._removeLink(link);
    return _getOwner(link);
  }
  void _rangeCheck(int start, int end) {
    if (start < 0 || start > this.length)
      throw new RangeError.range(start, 0, this.length);
    if (end < start || end > this.length)
      throw new RangeError.range(end, start, this.length);
  }
  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;
    if (skipCount < 0) throw new ArgumentError(skipCount);
    if (skipCount + length > iterable.length)
      throw new StateError("Not enough elements");

    final iter = iterable.skip(skipCount).iterator;
    if (start < this.length) {
      TreeLink dst = _at(start);
      while (--length >= 0) { //replace
        final value = (iter..moveNext()).current;
        final valueLink = _getLink(value);
        final next = dst._nextLink;
        if (!identical(dst, valueLink)) {
          _owner._removeLink(dst);
          _owner.addChild(value, _getOwner(next));
        }
        if ((dst = next) == null)
          break;
      }
    }
    while (--length >= 0) //append
      add((iter..moveNext()).current);
  }
  @override
  void removeRange(int start, int end) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;

    TreeLink link = _at(start);
    while (--length >= 0) {
      final TreeLink next = link._nextLink;
      _owner._removeLink(link);
      link = next;
    }
  }
  @override
  void fillRange(int start, int end, [T fill]) {
    _rangeCheck(start, end);
    int length = end - start;
    if (length == 0) return;
    if (length != 1)
      throw new UnsupportedError("Can fill only one child");
    this[start] = fill;
  }
  @override
  void insert(int index, T child) {
    _rangeCheck(index, this.length);
    _owner.addChild(child, index < this.length ? this[index]: null);
  }
  
  @override
  void set length(int newLength) {
    throw new UnsupportedError("Cannot set the length");
  }
  @override
  int indexOf(T child, [int start = 0]) {
    final link = _getLink(child);
    if (start >= length || link._parent != _owner)
      return -1;
    int i = start;
    for (TreeLink v = _at(max(start, 0)); v != null; v = v._nextLink) {
      if (v == link)
        return i;
      i++;
    }
    return -1;
  }
  @override
  int lastIndexOf(T child, [int start]) {
    final link = _getLink(child);
    if (start < 0 || link._parent != _owner)
      return -1;
    bool fromLast = start == null || start >= length - 1;
    int i = fromLast ? length - 1 : start;
    for (TreeLink v = fromLast ? _owner._lastLink: _at(start);
        v != null; v = v._prevLink) {
      if (v == link)
        return i;
      i--;
    }
    return -1;
  }
  @override
  bool remove(Object child) {
    if (child is T) {
      TreeLink link = _getLink(child);
      if (link._parent == _owner) {
        _owner._removeLink(link);
        return true;
      }
    }
    return false;
  }
  @override
  T removeAt(int index) {
    final link = _at(index);
    _owner._removeLink(link);
    return _getOwner(link);
  }
  @override
  void clear() {
    removeRange(0, length);
  }
  @override
  List<T> sublist(int start, [int end]) {
    if (end == null) end = length;
    _rangeCheck(start, end);

    final result = <T>[];
    TreeLink child = _at(start);
    for (int i = end - start; --i >= 0; child = child._nextLink)
      result.add(_getOwner(child));
    return result;
  }
}
