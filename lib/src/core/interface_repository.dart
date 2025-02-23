import 'package:flutter_base_components/src/models/abstract_model.dart';
import 'package:either_dart/either.dart';

abstract class InterfaceRepository<T extends AbstractModel> {
  final T? instanceType;
  final T Function(Map<String, dynamic>) fromJson;
  Map<String, dynamic> toJson(T entity) {
    return entity.toJson();
  }

  final String urlBaseModule;

  InterfaceRepository({
    this.instanceType,
    required this.fromJson,
    required this.urlBaseModule,
  });

  Future<Either<String, T>> save(T entity);
  Future<Either<String, List<T>>> saveAll(List<T> entitys);
  Future<Either<String, bool>> update(T entity);
  Future<Either<String, List<T>>> updateAll(List<T> entitys);
  Future<Either<String, bool>> delete(T entity);
  Future<Either<String, List<T>>> deleteAll(List<T> entitys);
  Future<Either<String, T>> findByField(String field, dynamic value);
  Future<Either<String, T>> findByUuid(String uuid);
  Future<Either<String, List<T>>> findAll({
    List<Map<String, dynamic>>? filters,
    List<Map<String, dynamic>>? orderBys,
  });
  Future<Either<String, List<T>>> findPaginated({
    int page = 1,
    int limit = 50,
    List<Map<String, dynamic>>? filters,
    List<Map<String, dynamic>>? orderBys,
  });
  Future<Either<String, dynamic>> uploadArchive(
    dynamic archiveModel, {
    Map<String, dynamic>? queryParameters,
    void Function(double)? onProgress,
  });
  Future<Either<String, T>> deactivate(T entity);
  Future<Either<String, T>> activate(T entity);
}
