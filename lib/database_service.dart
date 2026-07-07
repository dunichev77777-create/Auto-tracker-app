import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'Models/expense.dart';
import 'Models/maintenance_setting.dart';
import 'Models/vehicle.dart';

/// Сервис работы с локальной базой данных Isar.
/// Отвечает за инициализацию хранилища, CRUD-операции по расходам и категориям,
/// а также за чтение данных для аналитики и регламентов ТО.
class DatabaseService {
  /// Глобальный экземпляр базы данных Isar.
  static late Isar isar;
  /// Флаг, чтобы инициализация базы выполнялась только один раз.
  static bool _isInitialized = false;

  /// Инициализирует базу данных и открывает нужные коллекции Isar.
  /// Также заполняет базовые категории, если приложение запускается в первый раз.
  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ExpenseSchema, ExpenseCategorySchema, MaintenanceSettingSchema, VehicleSchema],
      directory: dir.path,
    );
    await _initDefaultCategories();
    await _initDefaultVehicle();
    _isInitialized = true;
  }

  /// Создаёт стандартный набор категорий, если база ещё не содержит ни одной.
  /// Это нужно для того, чтобы у пользователя сразу были базовые варианты: заправка, ТО и т.д.
  static Future<void> _initDefaultCategories() async {
    final count = await isar.expenseCategorys.count();
    if (count == 0) {
      await isar.writeTxn(() async {
        final systemCategories = [
          ExpenseCategory()..name = 'Заправка'..isSystem = true,
          ExpenseCategory()..name = 'ТО'..isSystem = true,
          ExpenseCategory()..name = 'Мойка'..isSystem = false,
          ExpenseCategory()..name = 'Запчасти'..isSystem = false,
        ];
        await isar.expenseCategorys.putAll(systemCategories);
      });
    }
  }

  /// Создаёт одно базовое транспортное средство, если база пока пуста.
  static Future<void> _initDefaultVehicle() async {
    final count = await isar.vehicles.count();
    if (count == 0) {
      await isar.writeTxn(() async {
        final vehicle = Vehicle()
          ..name = 'Мой автомобиль'
          ..plate = 'Не указано'
          ..isDefault = true;
        await isar.vehicles.put(vehicle);
      });
    }
  }

  // --- Управление транспортными средствами ---

  /// Возвращает список всех транспортных средств.
  static Future<List<Vehicle>> getAllVehicles() async {
    return await isar.vehicles.where().findAll();
  }

  /// Добавляет новое транспортное средство.
  static Future<void> addVehicle(String name, String? plate) async {
    await isar.writeTxn(() async {
      final vehicle = Vehicle()
        ..name = name
        ..plate = plate?.trim().isEmpty == true ? null : plate?.trim()
        ..isDefault = false;
      await isar.vehicles.put(vehicle);
    });
  }

  /// Обновляет данные транспортного средства.
  static Future<void> updateVehicle(Id id, String name, String? plate) async {
    await isar.writeTxn(() async {
      final vehicle = await isar.vehicles.get(id);
      if (vehicle != null) {
        vehicle.name = name;
        vehicle.plate = plate?.trim().isEmpty == true ? null : plate?.trim();
        await isar.vehicles.put(vehicle);
      }
    });
  }

  /// Удаляет транспортное средство, если оно не является единственным.
  static Future<bool> deleteVehicle(Id id) async {
    return await isar.writeTxn(() async {
      final vehicles = await isar.vehicles.where().findAll();
      if (vehicles.length <= 1) {
        return false;
      }
      return await isar.vehicles.delete(id);
    });
  }

  /// Возвращает текущее выбранное по умолчанию транспортное средство.
  static Future<Vehicle?> getDefaultVehicle() async {
    return await isar.vehicles.filter().isDefaultEqualTo(true).findFirst();
  }

  /// Устанавливает транспортное средство по умолчанию.
  static Future<void> setDefaultVehicle(Id id) async {
    await isar.writeTxn(() async {
      final vehicles = await isar.vehicles.where().findAll();
      for (final vehicle in vehicles) {
        vehicle.isDefault = vehicle.id == id;
        await isar.vehicles.put(vehicle);
      }
    });
  }

  // --- Управление категориями (CRUD) ---

  /// Возвращает список всех категорий расходов из базы.
  static Future<List<ExpenseCategory>> getAllCategories() async {
    return await isar.expenseCategorys.where().findAll();
  }

  /// Добавляет новую пользовательскую категорию в базу.
  static Future<void> addCategory(String name) async {
    await isar.writeTxn(() async {
      final cat = ExpenseCategory()..name = name..isSystem = false;
      await isar.expenseCategorys.put(cat);
    });
  }

  /// Обновляет название пользовательской категории.
  static Future<void> updateCategory(Id id, String newName) async {
    await isar.writeTxn(() async {
      final cat = await isar.expenseCategorys.get(id);
      if (cat != null && !cat.isSystem) {
        cat.name = newName;
        await isar.expenseCategorys.put(cat);
      }
    });
  }

  /// Удаляет пользовательскую категорию, если она не является системной.
  static Future<bool> deleteCategory(Id id) async {
    return await isar.writeTxn(() async {
      final cat = await isar.expenseCategorys.get(id);
      if (cat != null && !cat.isSystem) {
        return await isar.expenseCategorys.delete(id);
      }
      return false; // Системные удалять нельзя
    });
  }

  // --- Управление расходами и историей ---

  /// Сохраняет новую запись или обновляет существующую по идентификатору.
  static Future<void> saveExpense(Expense expense) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(expense); // .put() сам поймет: если ID новый — создаст, если старый — обновит
      await expense.category.save();
      await expense.vehicle.save();
    });
  }

  /// Удаляет запись расхода по её идентификатору.
  static Future<void> deleteExpense(Id id) async {
    await isar.writeTxn(() async {
      await isar.expenses.delete(id);
    });
  }

  /// Возвращает все расходы отсортированные по дате в порядке убывания.
  static Future<List<Expense>> getAllExpenses() async {
    return await isar.expenses.where().sortByDateDesc().findAll();
  }

  /// Возвращает расходы за выбранный период и при необходимости только для одного транспорта.
  static Future<List<Expense>> getExpensesForPeriod(DateTime start, DateTime end, {Id? vehicleId}) async {
    final endInclusive = end.add(const Duration(days: 1));
    var query = isar.expenses.filter().dateBetween(start, endInclusive, includeLower: true, includeUpper: true);
    if (vehicleId != null) {
      query = query.vehicle((q) => q.idEqualTo(vehicleId));
    }
    return await query.sortByDateDesc().findAll();
  }

  // --- Контроль пробега ---

  /// Возвращает максимальный пробег из существующих записей, если он есть.
  static Future<int> getLastOdometer() async {
    final lastExpense = await isar.expenses.where().sortByOdometerDesc().findFirst();
    return lastExpense?.odometer ?? 0;
  }

  // --- Аналитика расходов ---

  /// Собирает суммарные расходы по категориям за указанный период.
  static Future<Map<String, double>> getAnalyticsForPeriod(DateTime start, DateTime end, {Id? vehicleId}) async {
    final expenses = await getExpensesForPeriod(start, end, vehicleId: vehicleId);
    final Map<String, double> chartData = {};

    for (var expense in expenses) {
      // Подгружаем связь, если она еще ленивая
      if (!expense.category.isLoaded) {
        await expense.category.load();
      }
      final catName = expense.category.value?.name ?? 'Без категории';
      chartData[catName] = (chartData[catName] ?? 0.0) + expense.amount;
    }

    return chartData;
  }
  // --- Управление регламентами ТО ---

  /// Возвращает список настроек обслуживания; при пустой базе создаёт дефолтные значения.
  static Future<List<MaintenanceSetting>> getAllMaintenanceSettings() async {
    final settings = await isar.maintenanceSettings.where().findAll();

    // Если база пуста (первый запуск), заполним её дефолтными значениями.
    if (settings.isEmpty) {
      final defaultSettings = [
        MaintenanceSetting()
          ..title = 'Моторное масло'
          ..intervalKm = 10000
          ..lastChangedOdometer = 0
          ..lastChangedDate = DateTime.now()
          ..showOnMainScreen = true,
        MaintenanceSetting()
          ..title = 'Свечи зажигания'
          ..intervalKm = 30000
          ..lastChangedOdometer = 0
          ..lastChangedDate = DateTime.now()
          ..showOnMainScreen = true,
        MaintenanceSetting()
          ..title = 'Тормозная жидкость'
          ..intervalKm = 40000
          ..lastChangedOdometer = 0
          ..lastChangedDate = DateTime.now()
          ..showOnMainScreen = false,
      ];
      await isar.writeTxn(() async {
        await isar.maintenanceSettings.putAll(defaultSettings);
      });
      return defaultSettings;
    }

    return settings;
  }

  /// Добавляет новое правило обслуживания в базу.
  static Future<void> addMaintenanceSetting(MaintenanceSetting setting) async {
    await isar.writeTxn(() async {
      await isar.maintenanceSettings.put(setting);
    });
  }

  /// Обновляет интервал обслуживания и пробег последней замены для выбранного правила.
  static Future<void> updateMaintenanceSetting(Id id, int interval, int lastChanged, {bool? showOnMainScreen}) async {
    await isar.writeTxn(() async {
      final setting = await isar.maintenanceSettings.get(id);
      if (setting != null) {
        setting.intervalKm = interval;
        setting.lastChangedOdometer = lastChanged;
        if (showOnMainScreen != null) {
          setting.showOnMainScreen = showOnMainScreen;
        }
        await isar.maintenanceSettings.put(setting);
      }
    });
  }
}