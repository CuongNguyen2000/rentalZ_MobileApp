import 'package:rental_z/models/room.dart';
import 'package:rental_z/repositories/repository.dart';

class RoomService {
  Repository? _repository;
  RoomService() {
    _repository = Repository();
  }

  // Get all rooms
  getAllRooms() async {
    return await _repository!.getAllData('rooms');
  }

  // Get room by id
  getRoomById(id) async {
    return await _repository!.getDataById('rooms', id);
  }

  // Insert room
  insertRoom(Room room) async {
    return await _repository!.insertData('rooms', room.RoomMap());
  }

  // Update rooms by id
  Future<int> updateRoom(int id, String name, String descrption) async {
    final data = {
      'name': name,
      'description': descrption,
      'updated_at': DateTime.now().toString()
    };
    return await _repository!.updateData('rooms', data, id);
  }

  // Delete room by id
  deleteRoom(id) async {
    return await _repository!.deleteData('rooms', id);
  }

  // search room by name
  searchRoom(String name) async {
    return await _repository!.searchData('rooms', name);
  }
}
