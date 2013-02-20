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
   * Notice that the injection is done asynchronously. To continue after the injection is completed,
   * you have to invoke:
   *
   *     ObjectUtil.inject(obj, {"user.name": userName, "foo": whatever}).then((o) {
   *       //do something after completed
   *       //Note: o is the same as obj
   *     });
   *
   * * [obj] - the object to inject the value.
   * * [values] - the map of values. The key is the field name, such as `name`, `field1.field2` and so on.
   * * [coercer] - the coercer used to coercer the given object to the given type.
   * If omitted or null is returned, the default coercion will be done (it handles the basic types:
   * `int`, `double`, `String`, `num` and `Datetime`).
   * * [silent] - whether to ignore if the given field doesn't exist. If false (default), an exception
   * will be thrown.
   */
  static Future inject(Object obj, Map<String, dynamic> values,
  {Object coercer(Object o, ClassMirror targetClass), bool silent:false})
  => Future.forEach(values.keys, (key) {
      final fields = key.split('.');
      final value = values[key];
      if (fields.length == 1)
        return _inject(obj, key.trim(), value, coercer, silent);

      key = fields.removeLast();
      var o2 = obj;
      return Future.forEach(fields,
          (field) {
            field = field.trim();
            return reflect(o2).getField(field)
              .then((inst) {
                var o3 = inst.reflectee;
                if (o3 == null)
                  return ClassUtil.getSetterType(reflect(o2).type, field).newInstance("", []);
                    //1. use getSetterType since it will be assigned through setField
                    //2. assume there must be a default constructor. otherwise, it is caller's issue
                o2 = o3;
              })
              .then((inst) {
                if (inst != null) { //i.e., newInstance was called
                  var o3 = inst.reflectee;
                  _inject(o2, field, o3, null, false);
                  o2 = o3;
                }
              });
          }).then((_) => _inject(o2, key.trim(), value, coercer, silent));
    }).then((_) => obj);

  static Future _inject(Object obj, String name, Object value,
  Object coercer(Object o, ClassMirror targetClass), bool silent) {
    final clz = ClassUtil.getSetterType(reflect(obj).type, name);
    if (clz != null)
      return reflect(obj).setField(name,
          ClassUtil._convertParam(ClassUtil.coerce(value, clz, coercer: coercer)))
            //_convertParam to convert so-called non-simple-value to mirror
        .then((_) => obj);
    if (silent)
      return new Future.immediate(obj);
    throw new NoSuchMethodError(obj, name, null, null);
  }
}
