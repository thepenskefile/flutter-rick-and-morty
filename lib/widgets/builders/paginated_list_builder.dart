import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/request_response.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';
import 'package:rick_and_morty/widgets/builders/request_builder.dart';

typedef PaginatedListWidgetBuilder<T> = Widget Function(
  BuildContext context,
  RequestResponse<RickAndMortyPaginatedResponse<T>> requestResponse,
  ScrollController scrollController,
  bool isLastPage,
);

class PaginatedListBuilder<T> extends StatefulWidget {
  final PaginatedListWidgetBuilder<T> builder;
  final Future<RickAndMortyPaginatedResponse<T>> Function({int currentPage})
      future;

  const PaginatedListBuilder({
    super.key,
    required this.builder,
    required this.future,
  });

  @override
  State<PaginatedListBuilder<T>> createState() =>
      _PaginatedListBuilderState<T>();
}

class _PaginatedListBuilderState<T> extends State<PaginatedListBuilder<T>> {
  final ScrollController scrollController = ScrollController();
  bool isLastPage = false;
  int currentPage = 1;
  List<T>? data;

  Future<RickAndMortyPaginatedResponse<T>> getPaginatedData() async {
    final RickAndMortyPaginatedResponse<T> data = await widget.future(
      currentPage: currentPage,
    );
    currentPage = currentPage + 1;
    isLastPage = data.info.next == null;

    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RequestBuilder<RickAndMortyPaginatedResponse<T>>(
      future: getPaginatedData,
      isInfiniteResponse: true,
      builder: (context, requestResponse) {
        scrollController.addListener(() {
          var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;
          if (scrollController.position.pixels > nextPageTrigger &&
              !requestResponse.isPending) {
            requestResponse.isPending = true;
            requestResponse.load();
          }
        });

        return Container(
          child: widget.builder(
            context,
            requestResponse,
            scrollController,
            isLastPage,
          ),
        );
      },
    );
  }
}
