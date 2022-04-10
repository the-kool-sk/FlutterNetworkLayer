import 'package:network_layer_pro/base/base_endpoint.dart';
import 'package:network_layer_pro/base/endpoints.dart';

class FeatureEndpoint extends BaseEndpoint {
  final Map<String, dynamic> param;

  FeatureEndpoint(this.param) : super(Endpoints.feature, params: param);
}
