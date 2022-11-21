import 'package:flutter/material.dart';

import 'package:rick_and_morty/models/request_response.dart';
import 'package:rick_and_morty/services/rick_and_morty_api.dart';

typedef RequestWidgetBuilder<T> = Widget Function(
  BuildContext context,
  RequestResponse<T> requestResponse,
);

class RequestBuilder<T> extends StatefulWidget {
  final RequestWidgetBuilder<T> builder;
  final Future<T> Function() future;
  final bool isInfiniteResponse;

  const RequestBuilder({
    super.key,
    required this.builder,
    required this.future,
    required this.isInfiniteResponse,
  });

  @override
  State<RequestBuilder<T>> createState() => _RequestBuilderState<T>();
}

class _RequestBuilderState<T> extends State<RequestBuilder<T>> {
  bool isPending = false;
  bool isResolved = false;
  bool isRejected = false;
  T? response;
  Object? error;

  Future<void> getData() async {
    setState(() {
      isPending = true;
    });

    try {
      final T fetchedData = await widget.future();
      if (widget.isInfiniteResponse &&
          response is RickAndMortyPaginatedResponse) {
        (response as RickAndMortyPaginatedResponse)
            .results
            .addAll((fetchedData as RickAndMortyPaginatedResponse).results);
      } else {
        response = fetchedData;
      }

      setState(() {
        response = response;
        isResolved = true;
        isPending = false;
      });
    } catch (newError) {
      setState(() {
        isRejected = true;
        isPending = false;
        error = newError;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.builder(
        context,
        RequestResponse<T>(
          isPending: isPending,
          isResolved: isResolved,
          isRejected: isRejected,
          response: response,
          error: error,
          load: getData,
        ),
      ),
    );
  }
}
