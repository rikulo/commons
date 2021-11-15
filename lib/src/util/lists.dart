//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Tue, Jun 05, 2012  9:16:58 AM
// Author: tomyeh
part of rikulo_util;

/** List utilities.
 */
class ListUtil {
  ///Copy a list ([src]) to another ([dst])
  static List copy(List src, int srcStart,
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
    return dst;
  }

  /** Tests if a list equals another by comparing one-by-one
   *
	 * * [equal] - the closure to compare elements in the given lists.
   * If omitted, it compares each item in the list with `identical()`.
   */
  static bool equalsEach(List al, bl, [bool equal(a, b)?]) {
    if (identical(al, bl))
      return true;
    if (!(bl is List))
      return false;

    final bl2 = bl,
      length = al.length;
    if (length != bl2.length)
      return false;

    if (equal == null)
      equal = identical;
    for (int i = 0; i < length; i++) {
      if (!equal(al[i], bl2[i]))
        return false;
    }
    return true;
  }

  /** Returns the hash code of the given list
   */
  @Deprecated('Use Object.hashAll instead')
  static int getHashCode(Iterable? iterable)
  => iterable == null ? 0: Object.hashAll(iterable);
}
