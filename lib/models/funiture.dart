class Funiture {
  int? id;
  String? name;
  String? description;

  // ignore: non_constant_identifier_names
  FunitureMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    return mapping;
  }
}