import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:get/get.dart';

class TokoRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  TokoRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registerToko(String nama_merchant, String password) async {
    return await apiClient.postData(
        AppConstants.Toko_URL, {"name": nama_merchant, "password": password});
  }
}
