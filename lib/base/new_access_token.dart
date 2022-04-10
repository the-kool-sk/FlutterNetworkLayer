import 'base_endpoint.dart';
import 'endpoints.dart';

class GetNewAccessTokenEndPoint extends BaseEndpoint {
  Map<String, String> _map;

  GetNewAccessTokenEndPoint(this._map) : super(Endpoints.getAccessToken, params: _map);
}
