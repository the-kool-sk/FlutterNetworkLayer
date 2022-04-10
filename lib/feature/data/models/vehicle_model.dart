import 'package:network_layer_pro/base/base_model.dart';

import 'model.dart';

class VehicleModel implements BaseDataModel {
  List<String>? info;
  String? key;
  Model? model;
  @override
  ErrorModel? errorModel;

  VehicleModel({this.info, this.key, this.model, this.errorModel});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    if (info != null) {
      data['info'] = info;
    }
    if (model != null) {
      data['model'] = model?.toJson();
    }
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      info: json['info'] != null ? List<String>.from(json['info']) : [],
      key: json['key'],
      model: json['model'] != null ? Model().fromJson(json['model']) : {},
      errorModel: ErrorModel().fromJson(json["error"]),
    );
  }
}
