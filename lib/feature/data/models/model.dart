import '../../../base/base_model.dart';
import 'manufaturer.dart';

class Model extends BaseDataModel {
  Manufacturers? manufacturers;

  Model({this.manufacturers});

  @override
  fromJson(Map<String, dynamic> json) {
    return Model(
      manufacturers: json['manufacturers'] != null ? Manufacturers().fromJson(json['manufacturers']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (manufacturers != null) {
      data['manufacturers'] = manufacturers?.toJson();
    }
    return data;
  }
}
