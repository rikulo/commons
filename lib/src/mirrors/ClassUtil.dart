//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  02:51:12 PM
// Author: hernichen

part of rikulo_mirrors;

final ClassMirror _OBJECT_MIRROR = ClassUtil.forName("dart:core.Object");
final ClassMirror _MAP_MIRROR = ClassUtil.forName("dart:core.Map");

/** Utility class used with Mirror */
class ClassUtil {
  /**
   * Return the ClassMirror of the qualified class name
   *
   * + [qname] - qulified class name (libname.classname)
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
    throw new NoSuchClassException(qname);
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
    if (src is TypedefMirror) return false;

    //check superinterfaces and superclass
    for (ClassMirror inf in src.superinterfaces)
      if (isAssignableFrom(tgt, inf)) return true; //recursive

    return isAssignableFrom(tgt, src.superclass); //recursive
  }

  /** Returns the corresponding ClassMirror of a given TypeMirror.
   */
  static ClassMirror getCorrespondingClassMirror(TypeMirror type)
    => type is ClassMirror ? type : forName(type.qualifiedName);

  /**
   * Returns whether the specified class is a simple class;
   * i.e. num, bool, DateTime, String.
   *
   * + [cls] - the class
   */
  static bool isSimple(ClassMirror cls) {
    String qname = cls.qualifiedName;
    return qname == "dart:core.int" ||
           qname == "dart:core.double" ||
           qname == "dart:core.String" ||
           qname == "dart:core.DateTime" ||
           qname == "dart:core.bool";
  }

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
      Map<String, Object> nargs = new Map();
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
    => "dart:core.Object" == clz.qualifiedName || "void" == clz.qualifiedName;

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

  static String _toSetter(String name)
    => "set${name.substring(0, 1).toUpperCase()}${name.substring(1)}";

  /**
   * Returns the setter 'xxx' or 'setXxx" method of the class
   */
  static MethodMirror getSetter(ClassMirror cm, String name) {
    String sname = "$name=";
    String mname = _toSetter(name);
    MethodMirror setter = null;
    do {
      setter = cm.setters[sname];
      if (setter == null) //try setXxx
        setter = cm.methods[mname];
      if (setter != null && setter.parameters.length == 1)
        return setter;
    } while((cm = cm.superclass) != _OBJECT_MIRROR);
    return null;
  }
}
