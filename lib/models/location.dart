class Location {
  int id;
  String name;
  String type;
  String dimension;
  List<dynamic> residents;
  String url;
  String created;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  @override
  Location.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        dimension = json['dimension'],
        residents = json['residents'],
        url = json['url'],
        created = json['created'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'dimension': dimension,
      'residents': residents,
      'url': url,
      'created': created
    };
  }

  String get getName => name;
}
