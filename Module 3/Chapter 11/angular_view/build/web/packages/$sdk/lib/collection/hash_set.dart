// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of dart.collection;

/** Common parts of [HashSet] and [LinkedHashSet] implementations. */
abstract class _HashSetBase<E> extends SetBase<E> {

  // The following two methods override the ones in SetBase.
  // It's possible to be more efficient if we have a way to create an empty
  // set of the correct type.

  Set<E> difference(Set<Object> other) {
    Set<E> result = _newSet();
    for (var element in this) {
      if (!other.contains(element)) result.add(element);
    }
    return result;
  }

  Set<E> intersection(Set<Object> other) {
    Set<E> result = _newSet();
    for (var element in this) {
      if (other.contains(element)) result.add(element);
    }
    return result;
  }

  Set<E> _newSet();

  // Subclasses can optimize this further.
  Set<E> toSet() => _newSet()..addAll(this);
}

/**
 * An unordered hash-table based [Set] implementation.
 *
 * The elements of a `HashSet` must have consistent equality
 * and hashCode implementations. This means that the equals operation
 * must define a stable equivalence relation on the elements (reflexive,
 * anti-symmetric, transitive, and consistent over time), and that the hashCode
 * must consistent with equality, so that the same for objects that are
 * considered equal.
 *
 * The set allows `null` as an element.
 *
 * Most simple operations on `HashSet` are done in (potentially amorteized)
 * constant time: [add], [contains], [remove], and [length], provided the hash
 * codes of objects are well distributed.
 */
abstract class HashSet<E> implements Set<E> {
  /**
   * Create a hash set using the provided [equals] as equality.
   *
   * The provided [equals] must define a stable equivalence relation, and
   * [hashCode] must be consistent with [equals]. If the [equals] or [hashCode]
   * methods won't work on all objects, but only to instances of E, the
   * [isValidKey] predicate can be used to restrict the keys that they are
   * applied to. Any key for which [isValidKey] returns false is automatically
   * assumed to not be in the set.
   *
   * If [equals] or [hashCode] are omitted, the set uses
   * the objects' intrinsic [Object.operator==] and [Object.hashCode].
   *
   * If [isValidKey] is omitted, it defaults to testing if the object is an
   * [E] instance.
   *
   * If you supply one of [equals] and [hashCode],
   * you should generally also to supply the other.
   * An example would be using [identical] and [identityHashCode],
   * which is equivalent to using the shorthand [LinkedSet.identity]).
   */
  external factory HashSet({ bool equals(E e1, E e2),
                             int hashCode(E e),
                             bool isValidKey(potentialKey) });

  /**
   * Creates an unordered identity-based set.
   *
   * Effectively a shorthand for:
   *
   *     new HashSet(equals: identical, hashCode: identityHashCodeOf)
   */
  external factory HashSet.identity();

  /**
   * Create a hash set containing the elements of [iterable].
   *
   * Creates a hash set as by `new HashSet<E>()` and adds each element of
   * `iterable` to this set in the order they are iterated.
   */
  factory HashSet.from(Iterable<E> iterable) {
    return new HashSet<E>()..addAll(iterable);
  }

  /**
   * Provides an iterator that iterates over the elements of this set.
   *
   * The order of iteration is unspecified,
   * but consistent between changes to the set.
   */
  Iterator<E> get iterator;
}
