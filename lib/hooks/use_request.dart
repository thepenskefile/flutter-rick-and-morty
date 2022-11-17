import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RequestResponse<T> {
  bool isPending = false;
  bool isResolved = false;
  bool isRejected = false;
  List<T> response = [];
  Object? error;

  RequestResponse();

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

RequestResponse useRequest<T>({
  required BuildContext context,
  required Future<List<T>> Function() future,
}) {
  final RequestResponse requestResponse = RequestResponse<T>();
  final state = useState<RequestResponse<T>>(
    requestResponse as RequestResponse<T>,
  );
  useEffect(() {
    requestResponse.isPending = true;
    state.value = requestResponse;

    final promise = future();
    promise.then((result) {
      requestResponse.response = result;
      requestResponse.isResolved = true;
      requestResponse.isPending = false;
      state.value = requestResponse;
    });

    return () {};
  }, []);

  return state.value;
}
