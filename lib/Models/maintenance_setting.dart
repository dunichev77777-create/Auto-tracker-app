import 'package:isar/isar.dart';
import 'vehicle.dart';

part 'maintenance_setting.g.dart';

/// Модель правила технического обслуживания.
@collection
class MaintenanceSetting {
  /// Уникальный идентификатор правила.
  Id id = Isar.autoIncrement;

  /// Название элемента обслуживания, например «Моторное масло».
  late String title;

  /// Интервал обслуживания в километрах.
  late int intervalKm;

  /// Необязательный интервал в месяцах, если он используется в будущем.
  int? intervalMonths;

  /// Пробег, на котором была выполнена последняя замена.
  late int lastChangedOdometer;

  /// Дата последнего изменения или замены.
  late DateTime lastChangedDate;

  /// Идентификатор транспортного средства, к которому привязано правило.
  /// Используется вместо IsarLink из-за проблем с сохранением и фильтрацией.
  int? vehicleId;

  /// Связь с транспортным средством, для которого действует правило.
  final vehicle = IsarLink<Vehicle>();

  /// Показывать ли правило на главном экране мониторинга ТО.
  /// Значение по умолчанию false, чтобы старые записи из базы не ломали запуск.
  bool showOnMainScreen = false;

  bool matchesVehicleId(Id? targetVehicleId) {
    if (targetVehicleId == null) {
      return true;
    }

    if (vehicleId != null) {
      return vehicleId == targetVehicleId;
    }

    return vehicle.value?.id == targetVehicleId;
  }

  String get vehicleName => vehicle.value?.name ?? 'не выбрано';
}