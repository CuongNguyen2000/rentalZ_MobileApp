import 'package:rental_z/models/furniture.dart';
import 'package:rental_z/repositories/repository.dart';

class FurnitureService {
  Repository? _repository;
  FurnitureService() {
    _repository = Repository();
  }

  // Get all furnitures
  getAllFurnitures() async {
    return await _repository!.getAllData('furnitures');
  }

  // Get furniture by id
  getFurnitureById(id) async {
    return await _repository!.getDataById('furnitures', id);
  }

  // Add furniture
  insertFurniture(Furniture furniture) async {
    return await _repository!.insertData('furnitures', furniture.FurnitureMap());
  }

  // Update furniture
  updateFurniture(Furniture furniture) async {
    return await _repository!
        .updateData('furnitures', furniture.id, furniture.FurnitureMap());
  }

  // Delete furniture
  deleteFurniture(id) async {
    return await _repository!.deleteData('furnitures', id);
  }

  // search furnitures by name
  searchFurnitures(String name) async {
    return await _repository!.searchData('furnitures', name);
  }
}
