import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rick_and_morty/services/rick_and_morty_api.dart';

import '../models/character.dart';

class RequestResponse<T> {
  bool isPending = false;
  bool isResolved = false;
  bool isRejected = false;
  T? response;
  Object? error;
  Future<void> Function()? load;

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

RequestResponse<T> useRequest<T>({
  required Future<T> Function() future,
  bool isPaginatedResponse = false,
}) {
  final requestResponse = RequestResponse<T>();
  final state = useState<RequestResponse<T>>(
    requestResponse,
  );

  final test = useState<int>(0);

  Future<RequestResponse<T>> getData() async {
    print("REQUESTING");

    requestResponse.isPending = true;
    test.value = test.value + 1;

    try {
      final response = await future();
      // requestResponse = RequestResponse();

      if (isPaginatedResponse && requestResponse.response is RickAndMortyPaginatedResponse) {
        (requestResponse.response as RickAndMortyPaginatedResponse).results.addAll((response as RickAndMortyPaginatedResponse).results);
      } else {
        requestResponse.response = response;
      }
      requestResponse.isResolved = true;
      requestResponse.isPending = false;
      state.value = requestResponse;
      test.value = test.value + 1;

      return requestResponse;
    } catch (error) {
      requestResponse.isRejected = true;
      requestResponse.error = error;
      state.value = requestResponse;
      test.value = test.value + 1;
    }
    return requestResponse;
  }

  useEffect(() {
    requestResponse.load = getData;

    state.value = requestResponse;
    test.value = test.value + 1;

    requestResponse.load!();

    return () {};
  }, []);

  return state.value;

}
