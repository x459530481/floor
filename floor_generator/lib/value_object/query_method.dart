import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:floor_generator/misc/type_utils.dart';
import 'package:floor_generator/value_object/queryable.dart';

/// Wraps a method annotated with Query
/// to enable easy access to code generation relevant data.
class QueryMethod {
  final MethodElement methodElement;

  final String name;

  /// Query where ':' got replaced with '$'.
  final String query;

  final DartType rawReturnType;

  /// Flattened return type.
  ///
  /// E.g.
  /// Future<T> -> T,
  /// Future<List<T>> -> T
  ///
  /// Stream<T> -> T
  /// Stream<List<T>> -> T
  final DartType flattenedReturnType;

  final List<ParameterElement> parameters;

  final Queryable queryable;

  QueryMethod(
    this.methodElement,
    this.name,
    this.query,
    this.rawReturnType,
    this.flattenedReturnType,
    this.parameters,
    this.queryable,
  );

  bool get returnsList {
    final type = returnsStream
        ? rawReturnType.flatten()
        : methodElement.library.typeSystem.flatten(rawReturnType);

    return type.isDartCoreList;
  }

  bool get returnsStream => rawReturnType.isStream;

  bool get returnsVoid => flattenedReturnType.isVoid;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryMethod &&
          runtimeType == other.runtimeType &&
          methodElement == other.methodElement &&
          name == other.name &&
          query == other.query &&
          rawReturnType == other.rawReturnType &&
          flattenedReturnType == other.flattenedReturnType &&
          const ListEquality<ParameterElement>()
              .equals(parameters, other.parameters) &&
          queryable == other.queryable;

  @override
  int get hashCode =>
      methodElement.hashCode ^
      name.hashCode ^
      query.hashCode ^
      rawReturnType.hashCode ^
      flattenedReturnType.hashCode ^
      parameters.hashCode ^
      queryable.hashCode;

  @override
  String toString() {
    return 'QueryMethod{methodElement: $methodElement, name: $name, query: $query, rawReturnType: $rawReturnType, flattenedReturnType: $flattenedReturnType, parameters: $parameters, entity: $queryable}';
  }
}
