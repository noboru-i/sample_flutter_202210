import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.freezed.dart';
part 'api_client.g.dart';

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dio = Dio();
  dio.options.headers['Accept'] = 'application/vnd.github.v3+json';
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
  ));
  dio.httpClientAdapter = DefaultHttpClientAdapter()
    ..onHttpClientCreate = (client) {
      client.userAgent = 'sample_flutter_202210';
    };
  return ApiClient(dio);
}

@RestApi(baseUrl: 'https://api.github.com')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/search/repositories')
  Future<SearchResponse> searchRepositories(
    @Query('q') String q,
    @Query('per_page') int perPage,
    @Query('page') int page,
    @CancelRequest() CancelToken cancelToken,
  );
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
    required String fullName,
  }) = _Repository;

  factory Repository.fromJson(Map<String, Object?> json) =>
      _$RepositoryFromJson(json);
}
