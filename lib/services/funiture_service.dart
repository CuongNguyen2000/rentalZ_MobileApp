import 'package:rental_z/models/funiture.dart';
import 'package:rental_z/repositories/repository.dart';

class FunitureService {
  Repository? _repository;
  FunitureService() {
    _repository = Repository();
  }

  // Get all funitures
  getAllFunitures() async {
    return await _repository!.getAllData('funitures');
  }

  // Get funiture by id
  getFunitureById(id) async {
    return await _repository!.getDataById('funitures', id);
  }

  // Add funiture
  insertFuniture(Funiture funiture) async {
    return await _repository!.insertData('funitures', funiture.FunitureMap());
  }

  // Update funiture
  updateFuniture(Funiture funiture) async {
    return await _repository!
        .updateData('funitures', funiture.id, funiture.FunitureMap());
  }

  // Delete funiture
  deleteFuniture(id) async {
    return await _repository!.deleteData('funitures', id);
  }

  // search funitures by name
  searchFunitures(String name) async {
    return await _repository!.searchData('funitures', name);
  }
}
