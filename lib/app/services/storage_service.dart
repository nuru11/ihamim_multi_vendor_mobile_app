// lib/app/services/storage_service.dart
import 'package:get_storage/get_storage.dart';
import 'package:ihamim_multivendor/app/data/models/user_model.dart';

class StorageService {
  final _box = GetStorage();
  final _key = "user";

  Future<void> saveUser(UserModel user) async {
    await _box.write(_key, user.toJson());
  }

  UserModel? getUser() {
    final data = _box.read(_key);
    if (data == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> clearUser() async {
    await _box.remove(_key);
  }
}
