import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rick_and_morty/models/request_response.dart';
import 'package:rick_and_morty/models/location.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';
import 'package:rick_and_morty/widgets/builders/paginated_list_builder.dart';
import 'package:rick_and_morty/widgets/locations/location_list_item.dart';

class LocationsScreen extends HookWidget {
  const LocationsScreen({
    super.key,
  });

  Future<RickAndMortyPaginatedResponse<Location>> getLocations({
    int currentPage = 1,
  }) async {
    final data = await RickAndMortyApi().getLocations(
      params: {
        'page': currentPage.toString(),
      },
    );

    return data;
  }

  Widget _buildCharacterList({
    required RequestResponse requestResponse,
    required ScrollController scrollController,
    required bool isLastPage,
  }) {
    final locations = requestResponse.response?.results ?? [];
    if (locations == null || locations.isEmpty) {
      if (requestResponse.isPending) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        );
      } else if (requestResponse.isRejected) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text("Error"),
          ),
        );
      }
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: locations.length + (isLastPage ? 0 : 1),
      itemBuilder: ((context, index) {
        if (index == locations.length) {
          if (requestResponse.isPending) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (requestResponse.isRejected) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text("Error"),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            );
          }
        }

        final Location location = locations[index];
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: LocationListItem(location: location),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Locations"),
      ),
      body: PaginatedListBuilder<Location>(
        builder: (context, requestResponse, scrollController, isLastPage) {
          return _buildCharacterList(
            requestResponse: requestResponse,
            scrollController: scrollController,
            isLastPage: isLastPage,
          );
        },
        future: getLocations,
      ),
    );
  }
}
