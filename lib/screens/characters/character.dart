import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rick_and_morty/hooks/use_paginated_list.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/widgets/characters/character_list_item.dart';
import 'package:rick_and_morty/widgets/builders/paginated_list_builder.dart';

import '../../hooks/use_request.dart';

class CharacterScreen extends HookWidget {
  const CharacterScreen({
    super.key,
  });

  Future<RickAndMortyPaginatedResponse<Character>> getCharacters(
      {int currentPage = 1}) async {
    final data = await RickAndMortyApi().getCharacters(
      params: {'page': currentPage.toString()},
    );

    return data;
  }

  Widget _buildCharacterList({
    required RequestResponse requestResponse,
    required ScrollController scrollController,
    required bool isLastPage,
  }) {
    final characters = requestResponse.response?.results ?? [];
    if (characters == null || characters.isEmpty) {
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
      itemCount: characters.length + (isLastPage ? 0 : 1),
      itemBuilder: ((context, index) {
        if (index == characters.length) {
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

        final Character character = characters[index];
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: CharacterListItem(character),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginatedListResponse =
        usePaginatedList<Character>(future: getCharacters);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Characters"),
        ),
        body: _buildCharacterList(
          requestResponse: paginatedListResponse.requestResponse,
          scrollController: paginatedListResponse.scrollController,
          isLastPage: paginatedListResponse.isLastPage,
        )
        // body: PaginatedListBuilder<Character>(
        //   future: getCharacters,
        //   builder: (context, requestResponse, scrollConroller, isLastPage) {
        //     return _buildCharacterList(
        //       requestResponse: requestResponse,
        //       scrollController: scrollConroller,
        //       isLastPage: isLastPage,
        //     );
        //   },
        // ),
        );
  }
}
