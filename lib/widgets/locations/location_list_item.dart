import 'package:flutter/material.dart';

import 'package:rick_and_morty/models/location.dart';
import 'package:rick_and_morty/widgets/ui/shadow_container.dart';

class LocationListItem extends StatelessWidget {
  final Location location;

  const LocationListItem({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(location.getName),
      ),
    );
  }
}
