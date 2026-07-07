import 'package:isar/isar.dart';
import 'vehicle.dart';

part 'expense.g.dart';

/// Модель категории расхода для хранения в базе Isar.
@collection
class ExpenseCategory {
  /// Уникальный идентификатор категории.
  Id id = Isar.autoIncrement;

  /// Название категории, например: «Заправка», «Мойка», «ТО».
  @Index(unique: true)
  late String name;

  /// Признак системной категории, которую нельзя удалить из списка.
  late bool isSystem;
}

/// Модель записи расхода или события из истории.
@collection
class Expense {
  /// Уникальный идентификатор записи.
  Id id = Isar.autoIncrement;

  /// Дата и время, когда произошло событие.
  @Index()
  late DateTime date;

  /// Сумма расхода в рублях.
  late double amount;

  /// Пробег автомобиля на момент записи.
  late int odometer;

  /// Связь с категорией расхода.
  final category = IsarLink<ExpenseCategory>();

  /// Связь с транспортным средством, к которому относится запись.
  final vehicle = IsarLink<Vehicle>();

  /// Количество литров топлива для заправок.
  double? liters;

  /// Произвольный комментарий к записи.
  String? comment;
}