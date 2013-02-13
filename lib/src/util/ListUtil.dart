//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  9:16:58 AM
// Author: tomyeh
part of rikulo_util;

/** A readonly and empty list.
 */
const List EMPTY_LIST = const [];
/** A readonly and empty iterator.
 */
const Iterator EMPTY_ITERATOR = const _EmptyIter();

class _EmptyIter<T> implements Iterator<T> {
  const _EmptyIter();

  @override
  T get current => null;
  @override
  bool moveNext() => false;
}