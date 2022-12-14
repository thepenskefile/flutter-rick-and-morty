import 'package:flutter/material.dart';

import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/widgets/ui/shadow_container.dart';

class CharacterListItem extends StatelessWidget {
  final Character character;

  const CharacterListItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(character.getName),
      ),
    );
  }
}
