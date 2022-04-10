import 'package:network_layer_pro/base/base_model.dart';

class AccessTokenModel implements BaseDataModel {
  String? newAccessToken;

  AccessTokenModel({this.newAccessToken});

  @override
  fromJson(Map<String, dynamic> json) {
    return json['access'];
  }

  @override
  ErrorModel? errorModel;
}
