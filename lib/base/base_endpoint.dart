import 'dart:io';

import 'base_env.dart';

abstract class BaseEndpoint {
  BaseEndpoint(this.endpoint, {this.params = const {}});

  final String endpoint;
  final Map<String, dynamic> params;

  Future<Map<String, String>> get headers async {
    var accessToken = "\$2b\$10\$zN92ZQrV9.NNb9UQw9Q6fOUA80gV5/EmcrQIqEuYtc2uXcstMy..u";
    //Add other common headers param which you want to send to all APIs. Like device ID, app version, package name etc.

    return {
      if (accessToken != null) "secret-key": accessToken,
      "timezone": DateTime.now().timeZoneOffset.toString().split('.').first,
      "device-type": Platform.isAndroid ? "android" : "iOS",
      "Content-Type": "application/json",
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString()
    };
  }

  void addParams(Map<String, dynamic> params) {
    this.params.addAll(params);
  }

  String buildPathWith(BaseEnvironment env) {
    return env.baseURL() + '/' + endpoint;
  }
}
