import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rick_and_morty/hooks/use_paginated_list.dart';

import 'package:rick_and_morty/services/rick_and_morty_api.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/widgets/characters/character_list_item.dart';

class CharacterScreen extends HookWidget {
  const CharacterScreen({
    super.key,
  });

  Future<RickAndMortyPaginatedResponse<Character>> getCharacters({
    int currentPage = 1,
  }) async {
    final data = await RickAndMortyApi().getCharacters(
      params: {
        'page': currentPage.toString(),
      },
    );

    return data;
  }

  Widget _buildCharacterList({
    required PaginatedListResponse paginatedListResponse,
  }) {
    final scrollController = paginatedListResponse.scrollController;
    final requestResponse = paginatedListResponse.requestResponse;
    final isLastPage = paginatedListResponse.isLastPage;
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
          child: CharacterListItem(character: character),
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
        paginatedListResponse: paginatedListResponse,
      ),
    );
  }
}
