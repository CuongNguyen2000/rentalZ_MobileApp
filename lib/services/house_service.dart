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
  updateHouse(House house) async {
    return await _repository!.updateData('houses', house.id, house.HouseMap());
  }

  // Delete house by id
  deleteHouse(id) async {
    return await _repository!.deleteData('houses', id);
  }
}
