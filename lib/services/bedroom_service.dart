import 'package:rental_z/models/bedroom.dart';
import 'package:rental_z/repositories/repository.dart';

class BedroomService {
  Repository? _repository;
  BedroomService() {
    _repository = Repository();
  }

  // Get a list of all bedrooms
  getAllBedrooms() async {
    return await _repository!.getAllData('bedrooms');
  }

  // Get bedroom by id
  getBedroomById(id) async {
    return await _repository!.getDataById('bedrooms', id);
  }

  // Insert a new bedroom
  insertBedroom(Bedroom bedroom) async {
    return await _repository!.insertData('bedrooms', bedroom.BedroomMap());
  }

  // Update bedroom
  updateBedroom(Bedroom bedroom) async {
    return await _repository!
        .updateData('bedrooms', bedroom.id, bedroom.BedroomMap());
  }

  // Delete bedroom
  deleteBedroom(id) async {
    return await _repository!.deleteData('bedrooms', id);
  }
}
