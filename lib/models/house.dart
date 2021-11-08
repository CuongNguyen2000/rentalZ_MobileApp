class House {
  int? id;
  String? name;
  String? address;
  String? city;
  // String? image;
  String? description;
  int? price;
  String? reporter;
  String? room_type;
  String? bedroom_type;
  String? funiture_type;

  // ignore: non_constant_identifier_names
  HouseMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['address'] = address;
    mapping['city'] = city;
    // mapping['image'] = image;
    mapping['description'] = description;
    mapping['price'] = price;
    mapping['reporter'] = reporter;
    mapping['room_type'] = room_type;
    mapping['bedroom_type'] = bedroom_type;
    mapping['funiture_type'] = funiture_type;
    return mapping;
  }
}
