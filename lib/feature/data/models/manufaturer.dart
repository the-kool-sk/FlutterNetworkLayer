

import '../../../base/base_model.dart';

class Manufacturers extends BaseDataModel {
  String? name;
  int? yearOfEst;

  Manufacturers({this.name, this.yearOfEst});

  @override
  fromJson(Map<String, dynamic> json) {
    return Manufacturers(
      name: json['name'],
      yearOfEst: json['year_of_est'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['year_of_est'] = yearOfEst;
    return data;
  }
}
