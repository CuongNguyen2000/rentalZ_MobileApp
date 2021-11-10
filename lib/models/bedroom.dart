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
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;
    return mapping;
  }
}
