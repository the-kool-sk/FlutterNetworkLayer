import 'base_response.dart';

abstract class BaseAPIService {
  Future<BaseResponse> get(String url, Map<String, String> headers, Map<String, dynamic> params);

  Future<BaseResponse> post(String url, Map<String, String> headers, Map<String, dynamic> params);

  Future<BaseResponse> put(String url, Map<String, String> headers, Map<String, dynamic> params);

  Future<BaseResponse> delete(String url, Map<String, String> headers, Map<String, dynamic> params);
}
