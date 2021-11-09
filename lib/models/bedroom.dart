class Bedroom {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  // ignore: non_constant_identifier_names
  BedroomMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['createdAt'] = createdAt;
    mapping['updatedAt'] = updatedAt;
    return mapping;
  }
}
