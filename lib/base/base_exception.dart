abstract class BaseException {
  final String message;

  BaseException(this.message);
}

class ServerException extends BaseException {
  final String message;

  ServerException(this.message) : super(message);
}

class UserUnAuthException extends BaseException {
  final String message;

  UserUnAuthException(this.message) : super(message);
}

class GeneralException extends BaseException {
  final String message;

  GeneralException(this.message) : super(message);
}
