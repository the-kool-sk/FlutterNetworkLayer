abstract class BaseDataModel<T> {
  ErrorModel? errorModel;

  T fromJson(Map<String, dynamic> json);
}

class ErrorModel extends BaseDataModel {
  String errorMessage;
  int errorCode;

  ErrorModel({this.errorMessage = "something went wrong", this.errorCode = 404});

  @override
  fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      errorCode: json["error_code"],
      errorMessage: json["error_message"],
    );
  }
}
