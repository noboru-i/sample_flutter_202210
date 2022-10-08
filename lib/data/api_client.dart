import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.freezed.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api.github.com')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/search/repositories')
  Future<SearchResponse> searchRepositories(@Query('q') String q);
}

@freezed
class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    required int totalCount,
    required List<Repository> items,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, Object?> json) =>
      _$SearchResponseFromJson(json);
}

@freezed
class Repository with _$Repository {
  const factory Repository({
    required String name,
  }) = _Repository;

  factory Repository.fromJson(Map<String, Object?> json) =>
      _$RepositoryFromJson(json);
}
