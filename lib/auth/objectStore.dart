import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:novaone/novaOneTableHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:novaone/models/models.dart';
import 'package:novaone/utils/utils.dart';

/// A class to help us throw errors when items are not found in flutter secure storage
class MissingItemException implements Exception {
  final String message;
  const MissingItemException({required this.message});

  @override
  String toString() {
    return 'MissingItemException: $message';
  }
}

/// Stores objects locally to the device
class ObjectStore extends Equatable {
  final FlutterSecureStorage storage;
  final Future<SharedPreferences> prefs;

  /// The database instance needed for SQLlite storage
  final Database database;

  ObjectStore({
    required this.prefs,
    required this.storage,
    required this.database,
  });

  /// Encrypts and store the user password on the device
  ///
  /// Takes in the [password] and [email] to store
  Future<void> storeCredentials(
      {required String password, required String email}) async {
    await storage.write(key: Keys.instance.userPassword, value: password);
    await storage.write(key: Keys.instance.userUserName, value: email);
  }

  /// Stores the user data on the device
  Future<void> storeUser({required User user}) async {
    // Convert the user to JSON
    final String jsonUser = jsonEncode(user);

    // Save to device
    await storage.write(key: Keys.instance.userObject, value: jsonUser);
  }

  /// Stores the push notification on the device
  Future<void> storePushNotificationToken(String token) async {
    await storage.write(
        key: Keys.instance.userPushNotificationToken, value: token);
  }

  /// Gets the push notification on the device
  Future<String?> getPushNotificationToken() async {
    return await storage.read(key: Keys.instance.userPushNotificationToken);
  }

  /// Gets the push notification on the device
  Future<void> deletePushNotificationToken() async {
    await storage.delete(key: Keys.instance.userPushNotificationToken);
  }

  /// Gets the table associated with the type
  String _getTableNameForType<T extends BaseModel>() {
    switch (T) {
      case Lead:
        return NovaOneTableHelper.instance.leads;
      case Appointment:
        return NovaOneTableHelper.instance.appointmentsBase;
      case Company:
        return NovaOneTableHelper.instance.company;
      default:
        return NovaOneTableHelper.instance.leads;
    }
  }

  /// Stores [objects] data locally (leads, appointments, etc)
  ///
  /// The [objects] stored must extend the BaseModel type
  Future<void> storeObjects<T extends BaseModel>(List<T> objects) async {
    /// Get the table name
    final String tableName = _getTableNameForType<T>();

    /// Create a batch and insert in each object as a map
    final batch = database.batch();
    objects.forEach((object) {
      batch.insert(
        tableName,
        object.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit();
  }

  /// Gets all the objects for a tableName from local storage
  Future<List<T>> getObjects<T extends BaseModel>(
      {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    /// Get the table name
    final String tableName = _getTableNameForType<T>();

    final List<Map<String, dynamic>> maps = await database.query(tableName,
        where: where, whereArgs: whereArgs, orderBy: orderBy);

    /// Convert the maps to objects
    switch (T) {
      case Lead:
        return maps.map((json) => Lead.fromJson(json: json)).toList()
            as List<T>;
      case Appointment:
        return maps.map((json) => Appointment.fromJson(json: json)).toList()
            as List<T>;
      case Company:
        return maps.map((json) => Company.fromJson(json: json)).toList()
            as List<T>;
      default:
        print('ObjectStore.getObjects: Could not determine type');
        throw TypeError();
    }
  }

  /// Stores an indivdual [object] locally
  ///
  /// /// The [object] stored must extend the BaseModel type
  Future<void> storeObject<T extends BaseModel>(T object) async {
    /// Get the table name
    final String tableName = _getTableNameForType<T>();
    await database.insert(tableName, object.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Updates an indivdual [object] locally
  ///
  /// The [object] stored must extend the BaseModel type
  Future<void> updateObject<T extends BaseModel>(T object) async {
    /// Get the table name
    final String tableName = _getTableNameForType<T>();
    await database.update(tableName, object.toMap(),
        where: 'id = ?', whereArgs: [object.id]);
  }

  /// Deletes an indivdual [object] by [id] locally
  ///
  /// The [object] stored must extend the BaseModel type
  Future<int> deleteObject<T extends BaseModel>(int id) async {
    /// Get the table name
    final String tableName = _getTableNameForType<T>();
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Gets the count of the number of rows for the object of type [T]
  ///
  /// The objects counted must extend the BaseModel type
  Future<int?> getObjectCount<T extends BaseModel>() async {
    final String tableName = _getTableNameForType<T>();
    final result = await database.rawQuery('SELECT COUNT (*) from $tableName');
    return Sqflite.firstIntValue(result);
  }

  /// Gets the user data on the device
  Future<User?> getUser() async {
    // Get the user from saved data on the device
    final String? jsonUser = await storage.read(key: Keys.instance.userObject);
    if (jsonUser == null) return Future.value();

    return User.fromJson(json: jsonDecode(jsonUser));
  }

  /// Gets and decrypts the user's username stored in the device
  Future<String> getEmail() async {
    final String? username =
        await storage.read(key: Keys.instance.userUserName);
    if (username == null) {
      throw MissingItemException(message: 'Username has not been stored');
    }

    return username;
  }

  /// Gets and decrypts the user's password stored in the device
  Future<String> getPassword() async {
    final String? password =
        await storage.read(key: Keys.instance.userPassword);
    if (password == null) {
      throw MissingItemException(message: 'Password has not been stored');
    }

    return password;
  }

  /// Checks to see if the user has previously logged in and has credentials stored
  Future<bool> hasCredentials() async {
    final String? password =
        await storage.read(key: Keys.instance.userPassword);
    final String? username =
        await storage.read(key: Keys.instance.userUserName);

    return password != null && username != null;
  }

  /// Deletes the item in secure storage
  Future<void> deleteSecureStorageObject({required String key}) async {
    await storage.delete(key: key);
  }

  /// Clear all preferences local data on the device
  Future<void> clearData() async {
    /// Delete all data in tables
    try {
      final batch = database.batch();
      batch.delete(NovaOneTableHelper.instance.leads);
      batch.delete(NovaOneTableHelper.instance.appointmentsBase);
      batch.delete(NovaOneTableHelper.instance.company);
      await batch.commit();
    } catch (error) {
      throw Exception('ObjectStore.clearData: ${error.toString()}');
    }

    /// Delete all encrypted data as well
    await storage.deleteAll();
  }

  @override
  List<Object> get props => [storage];
}
