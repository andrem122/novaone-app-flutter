import 'package:equatable/equatable.dart';
import 'package:novaone/extensions/extensions.dart';

/// The base model class used for all models
abstract class BaseModel extends Equatable {
  BaseModel({required this.id});
  BaseModel.fromJson({required Map<String, dynamic> json, required this.id});

  final int id;

  Map<String, dynamic> toMap();

  /// Converts an int data type to a bool if needed
  ///
  /// If the [value] is already of type bool, then the method will
  /// return the value unaltered. This is needed because if we are converting
  /// a map object from local storage, the bool type in the map is converted
  /// to an int type with 0 being false and 1 being true, so we have to convert
  /// back to bool type.
  static bool convertIntToBool(dynamic value) {
    return value.runtimeType == bool ? (value as bool) : (value as int).toBool;
  }

  @override
  List<Object?> get props => [];
}
