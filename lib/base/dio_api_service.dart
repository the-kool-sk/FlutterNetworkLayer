import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_layer_pro/base/base_api_service.dart';

import 'base_log.dart';
import 'base_response.dart';

enum REQUEST_METHOD { POST, GET, DELETE, PUT }

class DioAPIService extends BaseAPIService {
  late Dio _dio;

  DioAPIService() {
    var options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      sendTimeout: 1000,
    );
    _dio = Dio(options);
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      logRequest(options.path, options.headers, options.method == "GET" ? options.queryParameters : options.data, options.method);
      handler.next(options);
    }, onResponse: (_, handler) async {
      logResponse(_);
      handler.next(_);
    }, onError: (_, handler) async {
      handler.next(_);
    }));
  }

  @override
  Future<BaseResponse> delete(String url, Map<String, String> headers, Map<String, dynamic> params) async {
    var response = await _dio
        .delete(url, queryParameters: params, options: Options(headers: headers, validateStatus: (status) => isValidResponse(status)))
        .onError((error, stackTrace) async {
      await logOnFirebase(error ?? "", stackTrace);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: getErrorResponse(),
        statusCode: HttpStatus.requestTimeout,
        statusMessage: "Timeout",
      );
    });
    return convertResponse(response);
  }

  @override
  Future<BaseResponse> get(String url, Map<String, String> headers, Map<String, dynamic> params) async {
    var response = await _dio
        .get(url, queryParameters: params, options: Options(headers: headers, validateStatus: (status) => isValidResponse(status)))
        .onError((error, stackTrace) async {
      await logOnFirebase(error ?? "", stackTrace);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: getErrorResponse(),
        statusCode: HttpStatus.requestTimeout,
        statusMessage: "Timeout",
      );
    });
    return convertResponse(response);
  }

  @override
  Future<BaseResponse> post(String url, Map<String, String> headers, Map<String, dynamic> params) async {
    var response = await _dio
        .post(url, data: params, options: Options(headers: headers, validateStatus: (status) => isValidResponse(status)))
        .onError((error, stackTrace) async {
      await logOnFirebase(error ?? "", stackTrace);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: getErrorResponse(),
        statusCode: HttpStatus.requestTimeout,
        statusMessage: "Timeout",
      );
    });
    return convertResponse(response);
  }

  @override
  Future<BaseResponse> put(String url, Map<String, String> headers, Map<String, dynamic> params) async {
    var response = await _dio
        .put(url, data: params, options: Options(headers: headers, validateStatus: (status) => isValidResponse(status)))
        .onError((error, stackTrace) async {
      await logOnFirebase(error ?? "", stackTrace);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: getErrorResponse(),
        statusCode: HttpStatus.requestTimeout,
        statusMessage: "Timeout",
      );
    });
    return convertResponse(response);
  }

  bool isValidResponse(int? status) => status! < 500 && status >= 1;

  BaseResponse convertResponse(Response response) {
    switch (response.statusCode) {
      case 401:
        return BaseResponse(response.data["data"], parseMetaData(response.data["meta_data"]), response.statusCode);
      case 408:
        return BaseResponse(response.data["data"], parseMetaData(response.data["meta_data"]), response.statusCode);
      case 200:
        return BaseResponse(response.data["data"], parseMetaData(response.data["meta_data"]), response.statusCode);
      case 403:
        return BaseResponse(response.data["data"], parseMetaData(response.data["meta_data"]), response.statusCode);
      default:
        //TODO: add other clauses here as per your requirement.
        return BaseResponse(response.data["data"], parseMetaData(response.data["meta_data"]), response.statusCode);
    }
  }

  void logRequest(String url, Map<String, dynamic> headers, Map<String, dynamic> params, String method) {
    fLog("NETWORK_CALL : RequestUrl " + url);
    fLog("NETWORK_CALL : RequestMethod " + method);
    fLog("NETWORK_CALL : RequestHeader " + headers.toString());
    fLog("NETWORK_CALL : RequestParams " + json.encode(params));
  }

  void logFormRequest(String url, Map<String, String> headers, FormData params, String method) {
    fLog("NETWORK_CALL : RequestUrl " + url);
    fLog("NETWORK_CALL : RequestMethod " + method);
    fLog("NETWORK_CALL : RequestHeader " + headers.toString());
    fLog("NETWORK_CALL : RequestParams " + params.toString());
  }

  void logResponse(Response response) {
    fLog("NETWORK_CALL : StatusCode " + response.statusCode.toString());
    fLog("NETWORK_CALL : StatusMessage " + response.statusMessage.toString());
    fLog("NETWORK_CALL : ResponseHeader " + response.headers.map.toString());
    fLog("NETWORK_CALL : Data " + json.encode(response.data));
  }

  MetaData parseMetaData(Map<String, dynamic> metaData) {
    return MetaData(
      metaData["show_to_user"],
      metaData["message"],
      metaData["display_type_code"],
    );
  }

  Future<void> logOnFirebase(Object error, StackTrace trace) async {
    try {
      logFirebaseError(error, trace, module: "network");
    } catch (e) {
      logFirebaseError(error, trace, module: "networkCatch");
    }
  }

  Map getErrorResponse() {
    return {
      "data": {
        "error": {
          "error_code": 504,
          "error_message": "Something went wrong",
        }
      },
      "meta_data": {
        "show_to_user": true,
        "message": "Something went wrong",
        "display_type_code": 1,
      }
    };
  }
}
