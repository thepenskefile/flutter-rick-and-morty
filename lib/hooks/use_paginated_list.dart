import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:rick_and_morty/models/request_response.dart';
import 'package:rick_and_morty/hooks/use_request.dart';
import 'package:rick_and_morty/services/rick_and_morty_api.dart';

class PaginatedListResponse {
  RequestResponse requestResponse;
  ScrollController scrollController;
  bool isLastPage;

  PaginatedListResponse({
    required this.requestResponse,
    required this.scrollController,
    required this.isLastPage,
  });

  Map toJson() {
    return {
      'requestResponse': requestResponse,
      'scrollController': scrollController,
      'isLastPage': isLastPage
    };
  }
}

PaginatedListResponse usePaginatedList<T>({
  required Future<RickAndMortyPaginatedResponse<T>> Function({int currentPage})
      future,
}) {
  final ScrollController scrollController = ScrollController();
  final currentPage = useState<int>(1);
  final isLastPage = useState<bool>(false);

  Future<RickAndMortyPaginatedResponse<T>> getPaginatedData() async {
    final data = await future(currentPage: currentPage.value);
    currentPage.value = currentPage.value + 1;
    isLastPage.value = data.info.next == null;

    return data;
  }

  RequestResponse<RickAndMortyPaginatedResponse<T>> requestResponse =
      useRequest(
    future: getPaginatedData,
    isInfiniteResponse: true,
  );

  scrollController.addListener(() {
    var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;
    if (scrollController.position.pixels > nextPageTrigger &&
        !requestResponse.isPending) {
      requestResponse.load();
    }
  });

  return PaginatedListResponse(
    requestResponse: requestResponse,
    scrollController: scrollController,
    isLastPage: isLastPage.value,
  );
}
