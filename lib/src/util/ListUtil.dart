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

/** List utilities.
 */
class ListUtil {
  ///Copy a list (src) to another (dst)
  static void copy(List src, int srcStart,
                   List dst, int dstStart, int count) {
    if (srcStart < dstStart) {
      for (int i = srcStart + count - 1, j = dstStart + count - 1;
           i >= srcStart; i--, j--) {
        dst[j] = src[i];
      }
    } else {
      for (int i = srcStart, j = dstStart; i < srcStart + count; i++, j++) {
        dst[j] = src[i];
      }
    }
  }

  ///Compares if a list equals another
  static bool equals(List a, Object b) {
    if (identical(a, b)) return true;
    if (!(b is List)) return false;
    int length = a.length;
    if (length != b.length) return false;

    for (int i = 0; i < length; i++) {
      if (!identical(a[i], b[i])) return false;
    }
    return true;
  }
}