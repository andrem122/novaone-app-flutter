import 'package:equatable/equatable.dart';
import 'package:novaone/models/models.dart';

abstract class NovaOneTableItemData extends Equatable {
  final int id;
  final String title;
  final String subtitle;

  /// The object that each table item corresponds to
  final BaseModel object;

  const NovaOneTableItemData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.object,
  });

  @override
  List<Object> get props => [title, subtitle];
}
