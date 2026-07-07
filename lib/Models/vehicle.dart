import 'package:isar/isar.dart';

part 'vehicle.g.dart';

/// Модель транспортного средства, которое может иметь собственную историю расходов.
@collection
class Vehicle {
  /// Уникальный идентификатор транспортного средства.
  Id id = Isar.autoIncrement;

  /// Отображаемое название автомобиля, например «Toyota Corolla».
  late String name;

  /// Государственный номер или дополнительное обозначение.
  String? plate;

  /// Признак, что это основное транспортное средство по умолчанию.
  late bool isDefault;
}
