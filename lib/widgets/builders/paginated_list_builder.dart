import 'package:flutter/material.dart';
import 'package:rick_and_morty/services/rick_and_morty_api.dart';

class RequestResponse<T> {
  bool isPending = false;
  bool isResolved = false;
  bool isRejected = false;
  List<T>? response = [];
  Object? error;

  RequestResponse({
    required this.isPending,
    required this.isResolved,
    required this.isRejected,
    this.response,
    this.error,
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

typedef PaginatedListWidgetBuilder = Widget Function(BuildContext context,
    RequestResponse requestResponse, ScrollController scrollController);

class PaginatedListBuilder<T> extends StatefulWidget {
  final PaginatedListWidgetBuilder builder;
  final Future<RickAndMortyPaginatedResponse<T>> Function({int currentPage})
      future;

  const PaginatedListBuilder(
      {super.key, required this.builder, required this.future});

  @override
  State<PaginatedListBuilder> createState() => _PaginatedListBuilderState<T>();
}

class _PaginatedListBuilderState<T> extends State<PaginatedListBuilder> {
  late RequestResponse<T> requestResponse;
  late ScrollController scrollController;
  late bool isLastPage;
  int currentPage = 1;
  late List<T> data;

  Future<void> getData() async {
    try {
      final RickAndMortyPaginatedResponse<T> response = await widget.future(
          currentPage: currentPage) as RickAndMortyPaginatedResponse<T>;
      setState(() {
        requestResponse.isPending = false;
        requestResponse.isResolved = true;
        data.addAll(response.results);
        requestResponse.response = data;
        isLastPage = response.info.next == null;
        currentPage = currentPage + 1;
      });
    } catch (error) {
      setState(() {
        requestResponse.isRejected = true;
        requestResponse.error = error;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLastPage = false;
    data = [];
    scrollController = ScrollController();
    requestResponse =
        RequestResponse(isPending: true, isResolved: false, isRejected: false);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;
      if (scrollController.position.pixels > nextPageTrigger &&
          !requestResponse.isPending) {
        requestResponse.isPending = true;
        getData();
      }
    });

    return Container(
      child: widget.builder(context, requestResponse, scrollController),
    );
  }
}
