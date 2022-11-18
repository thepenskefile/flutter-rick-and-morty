import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rick_and_morty/models/character.dart';

class RickAndMortyApi {
  static const rootUrl = 'https://rickandmortyapi.com/api';

  final client = http.Client();

  Future<RickAndMortyPaginatedResponse<Character>> getCharacters({
    params,
  }) async {
    final uri = Uri.https('www.rickandmortyapi.com', '/api/character', params);
    final response = await client.get(uri);
    Map<String, dynamic> data = json.decode(response.body);

    List<dynamic> dynamicList = data["results"];
    var characters = <Character>[];
    for (var character in dynamicList) {
      characters.add(Character.fromJson(character));
    }

    Map<String, dynamic> dynamicInfo = data["info"];
    final info = RickAndMortyInfo.fromJson(dynamicInfo);

    final paginatedResponse =
        RickAndMortyPaginatedResponse<Character>(characters, info);

    return paginatedResponse;
  }
}

class RickAndMortyPaginatedResponse<T> {
  late List<T> results;
  late RickAndMortyInfo info;

  RickAndMortyPaginatedResponse(this.results, this.info);
}

class RickAndMortyInfo {
  int count;
  int pages;
  String? next;
  String? previous;

  RickAndMortyInfo({
    required this.count,
    required this.pages,
    required this.next,
    this.previous,
  });

  RickAndMortyInfo.fromJson(Map json)
      : count = json['count'],
        pages = json['pages'],
        next = json['next'],
        previous = json['previous'];

  Map toJson() {
    return {
      'count': count,
      'pages': pages,
      'next': next,
      'previous': previous,
    };
  }
}
