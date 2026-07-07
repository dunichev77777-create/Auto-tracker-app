import 'package:isar/isar.dart';

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

  /// Показывать ли правило на главном экране мониторинга ТО.
  /// Значение по умолчанию false, чтобы старые записи из базы не ломали запуск.
  bool showOnMainScreen = false;
}