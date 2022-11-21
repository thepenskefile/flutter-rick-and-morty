import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';
import 'package:rick_and_morty/models/request_response.dart';

RequestResponse<T> useRequest<T>({
  required Future<T> Function() future,
  bool isInfiniteResponse = false,
}) {
  final isMounted = useIsMounted();
  final isPending = useState<bool>(false);
  final isResolved = useState<bool>(false);
  final isRejected = useState<bool>(false);
  final response = useState<T?>(null);
  final error = useState<Object?>(null);

  Future<void> getData() async {
    if (!isMounted()) return;

    isPending.value = true;

    try {
      final newResponse = await future();
      if (isInfiniteResponse &&
          response.value is RickAndMortyPaginatedResponse) {
        (response.value as RickAndMortyPaginatedResponse)
            .results
            .addAll((newResponse as RickAndMortyPaginatedResponse).results);
      } else {
        response.value = newResponse;
      }
      isResolved.value = true;
      isPending.value = false;
    } catch (newError) {
      if (!isMounted()) return;
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
