class ResponseModel<T> {
  final bool success;
  final String message;
  T? data;
  ResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
}
