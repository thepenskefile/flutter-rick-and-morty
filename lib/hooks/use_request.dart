import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';

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

RequestResponse<T> useRequest<T>({
  required Future<T> Function() future,
  bool isInfiniteResponse = false,
}) {

  var isPending = useState<bool>(false);
  var isResolved = useState<bool>(false);
  var isRejected = useState<bool>(false);
  var response = useState<T?>(null);
  var error = useState<Object?>(null);

  Future<void> getData() async {
    isPending.value = true;

    try {
      final newResponse = await future();
      if (isInfiniteResponse && response.value is RickAndMortyPaginatedResponse) {
        (response.value as RickAndMortyPaginatedResponse)
            .results
            .addAll((newResponse as RickAndMortyPaginatedResponse).results);
      } else {
        response.value = newResponse;
      }
      isResolved.value = true;
      isPending.value = false;
    } catch (newError) {
      isRejected.value = true;
      isPending.value = false;
      error.value = newError;
    }
  }

  useEffect(() {
    getData();
    return () {};
  }, []);

  return RequestResponse(
    isPending: isPending.value,
    isResolved: isResolved.value,
    isRejected: isRejected.value,
    response: response.value,
    error: error.value,
    load: getData,
  );
}
