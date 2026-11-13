// In your ApiResponse class (wherever it's defined)
class ApiResponse {
  final dynamic status; // Change from bool to dynamic
  final String? message;
  final dynamic data;
  final int? code;

  ApiResponse({required this.status, this.message, this.data, this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'], // Could be string "success" or boolean true
      message: json['message'],
      data: json['data'],
      code: json['code'],
    );
  }

  // Add a helper method to check if successful
  bool get isSuccess {
    if (status is bool) {
      return status == true;
    } else if (status is String) {
      return status == 'success';
    }
    return false;
  }
}
