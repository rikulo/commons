//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Tue, Feb 19, 2013 12:33:05 PM
// Author: tomyeh
part of rikulo_mirrors;

/**
 * Object utilities used with mirrors.
 */
class ObjectUtil {
  /** Injects the given values into the given object.
   *
   * Notice that the injection is done asynchronously. To continue after the
   * injection is completed,
   * you have to invoke:
   *
   *     ObjectUtil.inject(obj, {"user.name": userName, "foo": whatever}).then((o) {
   *       //do something after completed
   *       //Note: o is the same as obj
   *     });
   *
   * * [obj] - the object to inject the value.
   * * [values] - the map of values. The key is the field name, such as `name`,
   * `field1.field2` and so on.
   * * [coerce] - used to coerce the given object to the given type.
   * If omitted or null is returned, the default coercion will be done (
   * it handles the basic types: `int`, `double`, `String`, `num`, and `Datetime`).
   * * [onCoerceError] - used to handle the coercion error.
   * If not specified, the exception won't be caught.
   * * [onSetterError] - used to handle the error thrown by a setter.
   * If not specified, the exception won't be caught.
   ** [validate] - used to validate if the coerced value can be assigned.
   * * [silent] - whether to ignore if no field matches the keys of the given
   * values.
   * If false (default), an exception will be thrown.
   */
  static Future inject(Object obj, Map<String, dynamic> values,
      {coerce(value, ClassMirror targetClass),
      void onCoerceError(o, String field, value, ClassMirror targetClass, error),
      void onSetterError(o, String field, value, error),
      void validate(o, String field, value),
      bool silent: false})
  => Future.forEach(values.keys, (key) {
      final fields = key.split('.');
      final value = values[key];
      if (fields.length == 1)
        return _inject(obj, key.trim(), value,
            coerce, onCoerceError, onSetterError, validate, silent);

      //nothing to do if silent && no getter matches the first element of fields
      if (silent && ClassUtil.getGetterType(
          reflect(obj).type, fields.first.trim()) == null)
        return new Future.immediate(obj);

      key = fields.removeLast();
      var o2 = obj;
      return Future.forEach(fields, (field) {
        field = field.trim();
        final ret = reflect(o2).getField(field).then((inst) {
          final o3 = inst.reflectee;
          if (o3 == null) {
            final clz = ClassUtil.getSetterType(reflect(o2).type, field);
            if (clz == null)
              throw new NoSuchMethodError(o2, "$field=", null, null);
            return clz.newInstance("", []);
              //1. use getSetterType since it will be assigned through setField
              //2. assume there must be a default constructor. otherwise, it is caller's issue
          }
          o2 = o3;
          //no return to indicate no further processing
        })
        .then((inst) {
          if (inst != null) { //i.e., newInstance was called
            final o3 = inst.reflectee;
            return reflect(o2).setField(field, ClassUtil._convertParam(o3))
              .then((_) {
                o2 = o3;
              });
          }
        });
        return onSetterError == null ? ret: ret.catchError((err) {
          onSetterError(o2, field, null, err);
        });
      }).then((_) => _inject(o2, key.trim(), value,
          coerce, onCoerceError, onSetterError, validate, silent));
    }).then((_) => obj);

  static Future _inject(Object obj, String name, value,
      coerce(o, ClassMirror tClass),
      void onCoerceError(o, String field, value, ClassMirror tClass, err),
      void onSetterError(o, String field, value, err),
      void validate(o, String field, value),
      bool silent) {
    final clz = ClassUtil.getSetterType(reflect(obj).type, name);
    if (clz == null) { //not found
      if (!silent) {
        final err = new NoSuchMethodError(obj, "$name=", null, null);
        if (onSetterError == null)
          throw err;
        onSetterError(obj, name, value, err);
      }
      return new Future.immediate(obj);
    }

    if (onCoerceError != null) {
      try {
        value = ClassUtil.coerce(value, clz, coerce: coerce);
      } catch (ex) {
        onCoerceError(obj, name, value, clz, ex);
      }
    } else {
      value = ClassUtil.coerce(value, clz, coerce: coerce);
    }

    if (validate != null)
      validate(obj, name, value);

    final ret = reflect(obj).setField(name, ClassUtil._convertParam(value))
          //_convertParam to convert so-called non-simple-value to mirror
      .then((_) => obj);
    return onSetterError == null ? ret: ret.catchError((err) {
      onSetterError(obj, name, value, err);
    });
  }
}
