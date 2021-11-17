import 'package:rental_z/models/house.dart';
import 'package:rental_z/repositories/repository.dart';

class HouseService {
  Repository? _repository;
  HouseService() {
    _repository = Repository();
  }

  // Get a list of all houses
  getAllHouses() async {
    return await _repository!.getAllData('houses');
  }

  // Insert a new house
  insertHouse(House house) async {
    return await _repository!.insertData('houses', house.HouseMap());
  }

  // get a house by id
  getHouseById(id) async {
    return await _repository!.getDataById('houses', id);
  }

  // Update house by id
  Future<int> updateHouse(
      int id,
      String name,
      String address,
      String reporter,
      // String image,
      int price,
      String? note,
      String room_type,
      String bedroom_type,
      String furniture_type) async {
    final data = {
      'name': name,
      'address': address,
      'reporter': reporter,
      // 'image': image,
      'price': price,
      'note': note,
      'room_type': room_type,
      'bedroom_type': bedroom_type,
      'furniture_type': furniture_type,
      'updated_at': DateTime.now().toString()
    };
    return await _repository!.updateData('houses', data, id);
  }

  // Delete house by id
  deleteHouse(id) async {
    return await _repository!.deleteData('houses', id);
  }
}
