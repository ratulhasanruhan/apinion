class ResponseData {
  final bool isSuccess;
  final int statusCode;
  final dynamic data;
  final String error;

  ResponseData({
    required this.isSuccess,
    required this.statusCode,
    required this.data,
    required this.error,
  });
}
