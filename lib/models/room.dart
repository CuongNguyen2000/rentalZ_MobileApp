class Room {
  int? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  // ignore: non_constant_identifier_names
  RoomMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;
    return mapping;
  }
}
