//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Mon, Sep 03, 2012  02:51:12 PM
// Author: hernichen

part of rikulo_mirrors;

class Mirror {
  static final ClassMirror
    List = ClassUtil.forName("dart.core.List"),
    Map = ClassUtil.forName("dart.core.Map"),
    DateTime = ClassUtil.forName("dart.core.DateTime"),
    Queue = ClassUtil.forName("dart.collection.Queue"),
    Set = ClassUtil.forName("dart.core.Set"),
    String = ClassUtil.forName("dart.core.String"),
      //in later sdk, it is not the same as reflect("").type
    Object = ClassUtil.forName("dart.core.Object"),
    int = ClassUtil.forName("dart.core.int"),
      //in later sdk, it is not the same as reflect(0).type
    num = int.superclass!,
    double = ClassUtil.forName("dart.core.double"),
    bool = reflect(false).type;
}

/// Utility class used with Mirror.
class ClassUtil {
  /**
   * Return the ClassMirror of the qualified class name
   *
   * + [qname] - qualified class name (*libname.classname*), such as
   * `dart:core.List` and `rikulo_mirrors.ClassMirror`.
   */
  static ClassMirror forName(String qname) {
    final splited = _splitQualifiedName(qname);
   
    try {
      final lib = currentMirrorSystem().findLibrary(Symbol(splited["lib"]!)),
        klass = lib.declarations[Symbol(splited["class"]!)];
      if (klass is ClassMirror)
        return klass;
    } catch (e) {
      // findLibrary now throws if the symbol isn't there.
      throw NoSuchClassError(qname);
    }
    throw NoSuchClassError(qname);
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

    return isAssignableFrom(tgt, src.superclass!); //recursive
  }

  /**
   * Returns the generic element class of the collection class.
   */
  static ClassMirror getElementClassMirror(ClassMirror collection) {
    int idx = isAssignableFrom(Mirror.Map, collection) ? 1 : 0;
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
    return Mirror.Object;
  }

  /**
   * Returns whether the specified object is an instance of the specified class.
   *
   * + [classMirror] - the class
   * + [instance] - the object
   */
  static bool isInstance(ClassMirror classMirror, instance)
    => isAssignableFrom(classMirror, reflect(instance).type);

  static Map<String, String?> _splitQualifiedName(String qname) {
    int j = qname.lastIndexOf(".");
    return j < 1 || j >= (qname.length - 1) ?
      {"lib" : null, "class" : qname} :
      {"lib" : qname.substring(0, j), "class" : qname.substring(j+1)};
  }

  /**
   * Returns the types of the specified parameters
   */
  static List<TypeMirror> getParameterTypes(List<ParameterMirror> params) {
    final types = <TypeMirror>[];
    for (ParameterMirror param in params) {
//TODO(henri) : we have not supported named parameter
//      if (param.isNamed) {
//        continue;
//      }
      types.add(param.type);
    }
    return types;
  }

  /**
   * Invoke a method of the specified instance.
   *
   * + [instance] - the object instance.
   * + [method] - the method
   * + [params] - the positional + optional parameters.
   * + [namedArgs] - the optional named arguments. Ignored if the method is a getter or setter.
   */
  static invoke(instance, MethodMirror method, List params,
      [Map<String, dynamic>? namedArgs])
    => invokeByMirror(reflect(instance), method, params, namedArgs);
  /**
   * Invoke a method of the specified ObjectMirror.
   *
   * + [instance] - the ObjectMirror.
   * + [method] - the method.
   * + [params] - the positional + optional parameters.
   * + [namedArgs] - the optional named arguments. Ignored if the method is a getter or setter.
   */
  static invokeByMirror(ObjectMirror instance, MethodMirror method,
      List params, [Map<String, dynamic>? namedArgs]) {
    InstanceMirror result;
    if (method.isGetter) {
      result = instance.getField(method.simpleName);
    } else if (method.isSetter) {
      result = instance.setField(method.simpleName, params[0]);
    } else {
      result = instance.invoke(method.simpleName, params, _toNamedParams(namedArgs) ?? const <Symbol, dynamic>{});
    }
    return result.reflectee;
  }

  /**
   * apply a closure function.
   *
   * + [function] - the closure function.
   * + [params] - the positional + optional parameters.
   * + [namedArgs] - the optional named arguments.
   */
  static apply(Function function, List params,
      [Map<String, dynamic>? namedArgs])
    => applyByMirror(reflect(function) as ClosureMirror, params, namedArgs);
  /**
   * apply a closure mirror.
   *
   * + [function] - the closure mirror.
   * + [params] - the positional + optional parameters.
   * + [namedArgs] - the optional named arguments.
   */
  static applyByMirror(ClosureMirror function, List params,
      [Map<String, dynamic>? namedArgs])
    => function.apply(params, _toNamedParams(namedArgs) ?? const <Symbol, dynamic>{}).reflectee;

  ///Converts a map of named parameters to Symbol for synchronous invocation
  static Map<Symbol, dynamic>? _toNamedParams(Map<String, dynamic>? namedArgs) {
    if (namedArgs != null) {
      final nargs = HashMap<Symbol, dynamic>();
      namedArgs.forEach((k,v) => nargs[Symbol(k)] = v);
      return nargs;
    }
    return null;
  }

  /**
   * Returns whether the specified class is the top class (no super class).
   */
  static bool isTopClass(ClassMirror classMirror)
    => Mirror.Object.qualifiedName == classMirror.qualifiedName || "void" == classMirror.qualifiedName;

  /**
   * Create a new instance of the specified class name.
   */
  static newInstance(String className)
    => newInstanceByMirror(forName(className));
  /**
   * Create a new instance of the specified class mirror.
   */
  static newInstanceByMirror(ClassMirror classMirror)
    => classMirror.newInstance(const Symbol(""), []).reflectee; //unamed constructor

  /** Coerces the given object to the specified class ([targetClass]).
   *
   * * [coerce] - used to coerce the given object to the given type.
   * If omitted or null is returned, the default coercion will be done (it
   * handles the basic types: `int`, `double`, `String`, `num`, and `Datetime`).
   *
   * It throws [CoercionError] if failed to coerce.
   */
  static coerce(instance, ClassMirror targetClass,
      {coerce(o, ClassMirror tClass)?}) {
    if (coerce != null) {
      final o = coerce(instance, targetClass);
      if (o != null)
        return o;
    }
    if (instance == null)
      return instance;

    final clz = reflect(instance).type;
    if (isAssignableFrom(targetClass, clz))
      return instance;

    var sval = instance.toString();
    if (targetClass == Mirror.String)
      return sval;
    if (sval.isEmpty)
      return null;
    if (targetClass == Mirror.int)
      return int.parse(sval);
    if (targetClass == Mirror.double)
      return double.parse(sval);
    if (targetClass == Mirror.num)
      return sval.contains('.') ? double.parse(sval): int.parse(sval);
    if (targetClass == Mirror.DateTime)
      return DateTime.parse(sval);
    if (targetClass == Mirror.bool)
      return !sval.isEmpty && (sval = sval.toLowerCase()) != "false" && sval != "no"
        && sval != "off" && sval != "none";
    throw CoercionError(instance, targetClass);
  }

  /** Returns the class mirror of the given field (including setter), or null
   * if no such field nor setter.
   */
  static ClassMirror? getSetterType(ClassMirror classMirror, String field) {
    var mtd = classMirror.declarations[Symbol("$field=")];
    if (mtd is MethodMirror)
      return mtd.parameters[0].type as ClassMirror;

    mtd = classMirror.declarations[Symbol(field)];
    return mtd is VariableMirror ? mtd.type as ClassMirror: null;
  }
  /** Returns the class mirror of the given field (including getter), or null
   * if no such field nor getter.
   */
  static ClassMirror? getGetterType(ClassMirror classMirror, String field) {
    final mtd = classMirror.declarations[Symbol(field)];
    return mtd is MethodMirror ? mtd.returnType as ClassMirror:
        mtd is VariableMirror ? mtd.type as ClassMirror: null;
  }
}
