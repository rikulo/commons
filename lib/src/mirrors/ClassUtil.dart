//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  02:51:12 PM
// Author: hernichen

part of rikulo_mirrors;

final ClassMirror
//  _LIST_MIRROR = ClassUtil.forName("dart.core.List"),
  _MAP_MIRROR = ClassUtil.forName("dart.core.Map"),
  _DATE_TIME_MIRROR = ClassUtil.forName("dart.core.DateTime"),
  _NUM_MIRROR = ClassUtil.forName("dart.core.num"),
  _STRING_MIRROR = reflect("").type,
  _OBJECT_MIRROR = reflect(const Object()).type,
  _INT_MIRROR = reflect(0).type,
  _DOUBLE_MIRROR = reflect(0.0).type,
  _BOOL_MIRROR = reflect(false).type,
  _COLOR_MIRROR = reflect(WHITE).type;

/** Utility class used with Mirror. */
class ClassUtil {
  /**
   * Return the ClassMirror of the qualified class name
   *
   * + [qname] - qualified class name (libname.classname)
   */
  static ClassMirror forName(String qname) {
    Map splited = splitQualifiedName(qname);
    if (splited != null) {
      String libName = splited["libName"];
      String clsName = splited["clsName"];
      LibraryMirror l = currentMirrorSystem().libraries[libName];
      if (l != null) {
        ClassMirror m = l.classes[clsName];
        if (m != null) return m;
      }
    }
    throw new NoSuchClassError(qname);
  }

  /**
   * Returns whether a source class is assignable to target class.
   *
   * + [tgt] - target class
   * + [src] - source class
   */
  static bool isAssignableFrom(ClassMirror tgt, ClassMirror src) {
    if (tgt.qualifiedName == src.qualifiedName)
      return true;
    if (isTopClass(src)) //no more super class
      return false;

    //TypedefMirror does not implement superinterfaces/superclass
    if (src is TypedefMirror)
      return false;

    //check superinterfaces and superclass
    for (ClassMirror inf in src.superinterfaces)
      if (isAssignableFrom(tgt, inf))
        return true; //recursive

    return isAssignableFrom(tgt, src.superclass); //recursive
  }

  /** Returns the corresponding ClassMirror of a given TypeMirror.
   */
  static ClassMirror getCorrespondingClassMirror(TypeMirror type)
    => type is ClassMirror ? type : forName(type.qualifiedName);

  /**
   * Returns the generic element class of the collection class.
   */
  static ClassMirror getElementClassMirror(ClassMirror collection) {
    int idx = isAssignableFrom(_MAP_MIRROR, collection) ? 1 : 0;
    return _getElementClassMirror0(collection, idx);
  }

  /**
   * Returns the generic key class of the map class.
   */
  static ClassMirror getKeyClassMirror(ClassMirror map)
    => _getElementClassMirror0(map, 0);

  static ClassMirror _getElementClassMirror0(ClassMirror collection, int idx) {
//TODO(henri): Dart have not implemented typeArguments!
//    List<TypeMirror> vars = collection.typeArguments.getValues();
//    return getCorrespondingClassMirror(vars[idx]);
    return _OBJECT_MIRROR;
  }

  /**
   * Returns whether the specified object is an instance of the specified class.
   *
   * + [cls] - the class
   * + [obj] - the object
   */
  static bool isInstance(ClassMirror cls, Object obj)
    => isAssignableFrom(cls, reflect(obj).type);

  static Map splitQualifiedName(String qname) {
    int j = qname.lastIndexOf(".");
    return j < 1 || j >= (qname.length - 1) ?
      {"libName" : null, "clsName" : qname} :
      {"libName" : qname.substring(0, j), "clsName" : qname.substring(j+1)};
  }

  /**
   * Returns the types of the specified parameters
   */
  static List<ClassMirror> getParameterTypes(List<ParameterMirror> params) {
    List<ClassMirror> types = new List();
    for (ParameterMirror param in params) {
//TODO(henri) : we have not supported named parameter
//      if (param.isNamed) {
//        continue;
//      }
      types.add(getCorrespondingClassMirror(param.type));
    }
    return types;
  }

  /**
   * Invoke a method of the specified instance.
   *
   * + [inst] - the object instance.
   * + [m] - the method
   * + [params] - the positional + optional parameters.
   * + [nameArgs] - the optional named arguments.
   */
  static Future invoke(Object inst, MethodMirror m, List<Object> params,
                       [Map<String, Object> namedArgs])
    => invokeObjectMirror(reflect(inst), m, params, namedArgs);

  /**
   * Invoke a method of the specified ObjectMirror.
   *
   * + [inst] - the ObjectMirror.
   * + [m] - the method.
   * + [params] - the positional + optional parameters.
   * + [nameArgs] - the optional named arguments.
   */
  static Future invokeObjectMirror(ObjectMirror inst, MethodMirror m,
      List<Object> params, [Map<String, Object> namedArgs]) {
    Future<InstanceMirror> result;
    if (m.isGetter)
      result = inst.getField(m.simpleName);
    else if (m.isSetter) {
      String fieldnm = m.simpleName.substring(0, m.simpleName.length-1);
      result = inst.setField(fieldnm, _convertParam(params[0]));
    } else {
      params = _convertParams(params);
      namedArgs = _convertNamedArgs(namedArgs);

      result = inst.invoke(m.simpleName, params, namedArgs);
    }
    return result.then((value) => value.reflectee);
  }

  /**
   * apply a closure function.
   *
   * + [fn] - the closure function.
   * + [params] - the positional + optional parameters.
   * + [nameArgs] - the optional named arguments.
   */
  static Future apply(Function fn, List<Object> params, [Map<String, Object> namedArgs]) {
    ClosureMirror closure = reflect(fn);
    params = _convertParams(params);
    namedArgs = _convertNamedArgs(namedArgs);
    Future<InstanceMirror> result = closure.apply(params, namedArgs);
    return result.then((value) => value.reflectee);
  }

  static List _convertParams(List params) {
    if (params != null) {
      List ps = new List();
      params.forEach((v) => ps.add(_convertParam(v)));
      return ps;
    }
    return null;
  }

  static Map<String, Object> _convertNamedArgs(Map namedArgs) {
    if (namedArgs != null) {
      Map<String, Object> nargs = new HashMap();
      namedArgs.forEach((k,v) => nargs[k] = _convertParam(v));
      return nargs;
    }
    return null;
  }

  static Object _convertParam(var v) {
    if (v == null || v is num || v is bool || v is String || v is Mirror)
      return v;
    return reflect(v);
  }

  /**
   * Returns whether the specified class is the top class (no super class).
   */
  static bool isTopClass(ClassMirror clz)
    => _OBJECT_MIRROR.qualifiedName == clz.qualifiedName || "void" == clz.qualifiedName;

  /**
   * Create a new instance of the specified class name.
   */
  static Future newInstance(String className) {
    ClassMirror clz = forName(className);
    return newInstanceByClassMirror(clz);
  }

  static Future newInstanceByClassMirror(ClassMirror clz) {
    Future<InstanceMirror> inst = clz.newInstance("", []); //unamed constructor
    return inst.then((value) => value.reflectee);
  }

  /** Coerces the given object to the specified class ([targetClass]).
   *
   * * [coerce] - used to coerce the given object to the given type.
   * If omitted or null is returned, the default coercion will be done (it
   * handles the basic types: `int`, `double`, `String`, `num`, `Datetime`
   * and `Color`).
   *
   * It throws [CoercionError] if failed to coerce.
   */
  static coerce(Object obj, ClassMirror targetClass,
      {coerce(o, ClassMirror tClass)}) {
    if (coerce != null) {
      final o = coerce(obj, targetClass);
      if (o != null)
        return o;
    }
    if (obj == null)
      return obj;

    final clz = reflect(obj).type;
    if (isAssignableFrom(targetClass, clz))
      return obj;

    var sval = obj.toString();
    if (targetClass == _STRING_MIRROR)
      return sval;
    if (sval.isEmpty)
      return null;
    if (targetClass == _INT_MIRROR)
      return int.parse(sval);
    if (targetClass == _DOUBLE_MIRROR)
      return double.parse(sval);
    if (targetClass == _NUM_MIRROR)
      return sval.indexOf('.') >= 0 ? double.parse(sval): int.parse(sval);
    if (targetClass == _DATE_TIME_MIRROR)
      return DateTime.parse(sval);
    if (targetClass == _BOOL_MIRROR)
      return !sval.isEmpty && (sval = sval.toLowerCase()) != "false" && sval != "no"
        && sval != "off" && sval != "none";
    if (targetClass == _COLOR_MIRROR)
      return Color.parse(sval);
    throw new CoercionError(obj, targetClass);
  }

  /** Returns the class mirror of the given field (including setter), or null
   * if no such field nor setter.
   */
  static ClassMirror getSetterType(ClassMirror clz, String field) {
    var mtd = clz.setters["$field="];
    if (mtd != null)
      return mtd.parameters[0].type;

    mtd = clz.members[field];
    return mtd is VariableMirror ? mtd.type: null;
  }
  /** Returns the class mirror of the given field (including getter), or null
   * if no such field nor getter.
   */
  static ClassMirror getGetterType(ClassMirror clz, String field) {
    var mtd = clz.getters[field];
    if (mtd != null)
      return mtd.returnType;

    mtd = clz.members[field];
    return mtd is VariableMirror ? mtd.type: null;
  }
}
