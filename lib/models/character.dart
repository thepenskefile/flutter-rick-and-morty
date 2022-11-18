class Character {
  int id;
  String name;
  String status;
  String species;
  String type;
  String gender;
  Map<String, dynamic> origin;
  Map<String, dynamic> location;
  String image;
  List<dynamic> episode;
  String url;
  String created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  @override
  Character.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        species = json['species'],
        type = json['type'],
        gender = json['gender'],
        origin = json['origin'],
        location = json['location'],
        image = json['image'],
        episode = json['episode'],
        url = json['url'],
        created = json['created'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
      'episode': episode,
      'url': url,
      'created': created
    };
  }

  String get getName => name;
}
