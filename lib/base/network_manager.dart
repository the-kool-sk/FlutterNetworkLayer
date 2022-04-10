import 'package:network_layer_pro/base/base_api_service.dart';
import 'package:network_layer_pro/base/base_endpoint.dart';
import 'package:network_layer_pro/base/base_exception.dart';
import 'access_token_Model.dart';
import 'base_env.dart';
import 'base_log.dart';
import 'base_model.dart';
import 'base_response.dart';
import 'dio_api_service.dart';
import 'new_access_token.dart';

class NetworkManager {
  bool _isFreshAccessTokenRequested = false;

  //This should be dynamic, but this not in scope of this article we will see this in some other article
  static final BaseEnvironment _currentEnvironment = BaseEnvironment();

  final BaseAPIService _apiService;

  NetworkManager(this._apiService);

  BaseEnvironment get currentEnvironment => _currentEnvironment;

  Future<R> get<R, T extends BaseDataModel>(BaseEndpoint endpoint, T parseModel) async {
    var response = await _apiService.get(endpoint.buildPathWith(_currentEnvironment), await endpoint.headers, endpoint.params);
    return _parseResponse<R, T>(response, endpoint, parseModel, REQUEST_METHOD.GET);
  }

  Future<R> post<R, T extends BaseDataModel>(BaseEndpoint endpoint, T parseModel) async {
    var response = await _apiService.post(endpoint.buildPathWith(_currentEnvironment), await endpoint.headers, endpoint.params);
    return _parseResponse<R, T>(response, endpoint, parseModel, REQUEST_METHOD.POST);
  }

  Future<R> put<R, T extends BaseDataModel>(BaseEndpoint endpoint, T parseModel) async {
    var response = await _apiService.put(endpoint.buildPathWith(_currentEnvironment), await endpoint.headers, endpoint.params);
    return _parseResponse<R, T>(response, endpoint, parseModel, REQUEST_METHOD.POST);
  }

  Future<R> delete<R, T extends BaseDataModel>(BaseEndpoint endpoint, T parseModel) async {
    var response = await _apiService.delete(endpoint.buildPathWith(_currentEnvironment), await endpoint.headers, endpoint.params);
    return _parseResponse<R, T>(response, endpoint, parseModel, REQUEST_METHOD.DELETE);
  }

  Future<R> _parseResponse<R, T extends BaseDataModel>(BaseResponse response, BaseEndpoint endpoint, T parseModel, REQUEST_METHOD method) async {
    //TODO:Dismiss your loader here like this:
    //await EasyLoading.dismiss();
    _handleDisplayToUser(response.metaData);
    if (response.httpStatusCode! >= 1 && response.httpStatusCode! <= 300) {
      return _parseModel<R, T>(response.data, parseModel);
    } else if (response.httpStatusCode! == 401) {
      if (!_isFreshAccessTokenRequested) {
        return handleUnAuthResponse(response, endpoint, method, parseModel);
      } else {
        fLog('Unauthorised access both tokens are expired logging out user.');
        logoutUser();
        throw UserUnAuthException("Unauthorised Access");
      }
    } else if (response.httpStatusCode! == 403) {
      fLog('User Logged into another device');
      logoutUser();
      throw UserUnAuthException("Unauthorised Access");
    } else {
      throw ServerException("Something terribly went wrong");
    }
  }

  Future<R> _parseModel<R, T extends BaseDataModel>(dynamic responseBody, T model) async {
    if (responseBody is List) {
      return responseBody.map((data) => model.fromJson(data)).cast<T>().toList() as R;
    } else {
      return model.fromJson(responseBody['data']['result']) as R;
    }
  }

  Future<R> handleUnAuthResponse<R, T extends BaseDataModel>(
      BaseResponse response, BaseEndpoint endpoint, REQUEST_METHOD method, T parseModel) async {
    _isFreshAccessTokenRequested = true;
    String? newAccessToken = await requestFreshAccessToken();
    return handleNewAccessTokenResponse(newAccessToken, endpoint, method, parseModel);
  }

  Future<String> requestFreshAccessToken() async {
    //TODO: Pull Refresh toke from local storage
    var refresh = {"refresh": ""};
    var getNewAccessTokenEndPoint = GetNewAccessTokenEndPoint(refresh);
    try {
      //TODO : Request new token something like this :
      return await post(getNewAccessTokenEndPoint, AccessTokenModel());
    } on Exception catch (exception) {
      fLog(exception.toString());
      logoutUser();
      throw UserUnAuthException("Unauthorised Access");
    }
  }

  Future<R> handleNewAccessTokenResponse<R, T extends BaseDataModel>(
      String? response, BaseEndpoint endpoint, REQUEST_METHOD method, T parseModel) async {
    try {
      if (response != null) {
        return saveAndSendPreviousRequest(endpoint, method, parseModel, response);
      } else {
        return logoutUser();
      }
    } on Exception catch (e) {
      fLog(e.toString());
      throw UserUnAuthException("Unauthorised Access");
    }
  }

  Future<R> saveAndSendPreviousRequest<R, T extends BaseDataModel>(
      BaseEndpoint endpoint, REQUEST_METHOD method, T parseModel, String response) async {
    //TODO: Save new access token to local storage here.
    _isFreshAccessTokenRequested = false;
    switch (method) {
      case REQUEST_METHOD.POST:
        return await post(endpoint, parseModel);
      case REQUEST_METHOD.GET:
        return await get(endpoint, parseModel);
      case REQUEST_METHOD.DELETE:
        return await delete(endpoint, parseModel);
      case REQUEST_METHOD.PUT:
        return await put(endpoint, parseModel);
    }
  }

  Future<R> logoutUser<R extends BaseDataModel>() {
    fLog('Unauthorised request logging out user');
    //TODO: Perform logout activities.
    throw UserUnAuthException("Unauthorised Access");
  }

  void _handleDisplayToUser(MetaData metaData) {
    if (metaData.showToUser) {
      switch (metaData.displayMethod) {
        case 1:
          {
            //TODO:Show toast message
            break;
          }
        case 2:
          {
            //TODO:Show dialog box
            break;
          }
        case 3:
          {
            //TODO:Show snackbar
            break;
          }
        default:
          {
            //TODO:Show toast
            break;
          }
      }
    }
  }
}
