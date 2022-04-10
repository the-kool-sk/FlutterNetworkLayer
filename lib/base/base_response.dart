import 'package:network_layer_pro/base/base_model.dart';

class BaseResponse<T> {
  BaseResponse(this.data, this.metaData, this.httpStatusCode);

  final int? httpStatusCode;
  final dynamic data;
  final MetaData metaData;
}

class MetaData extends BaseDataModel {
  final bool showToUser;
  final String message;
  final int displayMethod;

  MetaData(this.showToUser, this.message, this.displayMethod);

  @override
  fromJson(Map<String, dynamic> json) {
    return MetaData(
      json["show_to_user"],
      json["message"],
      json["display_type_code"],
    );
  }
}
