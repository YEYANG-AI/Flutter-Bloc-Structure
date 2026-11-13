class NetworkApiPaths {
  static String baseURL = 'https://backend.sjiinvestment.la';
  static String baseURLSocket = 'wss://backend.sjiinvestment.la/demo';

  static const String getRequest = 'get';
  static const String postRequest = 'post';
  static const String putRequest = 'put';
  static const String patchRequest = 'patch';
  static const String deleteRequest = 'delete';

  static String loginPath = '$baseURL/api/v1/auth/login';
}
