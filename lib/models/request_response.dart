class RequestResponse<T> {
  bool isPending = false;
  bool isResolved = false;
  bool isRejected = false;
  T? response;
  Object? error;
  Future<void> Function() load;

  RequestResponse({
    required this.isPending,
    required this.isResolved,
    required this.isRejected,
    required this.response,
    required this.error,
    required this.load,
  });

  Map toJson() {
    return {
      'isPending': isPending,
      'isResolved': isResolved,
      'isRejected': isRejected,
      'response': response,
      'error': error,
    };
  }
}