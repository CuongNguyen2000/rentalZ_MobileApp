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

  // Update rooms by id
  updateRoom(Room room) async {
    return await _repository!.updateData('rooms', room.id, room.RoomMap());
  }

  // Delete room by id
  deleteRoom(id) async {
    return await _repository!.deleteData('rooms', id);
  }
}
