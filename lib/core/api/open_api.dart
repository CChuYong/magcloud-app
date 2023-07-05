import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'open_api.g.dart';

@RestApi()
abstract class OpenAPI {
  factory OpenAPI(Dio dio, {String baseUrl}) = _OpenAPI;

  @GET('/tags')
  Future<dynamic> onlineCheck();
}
