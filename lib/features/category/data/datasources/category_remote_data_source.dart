import 'package:dio/dio.dart';

import '../models/category_model.dart';

const String kCategoryApiBaseUrl = 'https://mockapi.example.com';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> fetchCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this.client);

  final Dio client;

  @override
  Future<List<CategoryModel>> fetchCategories() {
    throw UnimplementedError();
  }
}
