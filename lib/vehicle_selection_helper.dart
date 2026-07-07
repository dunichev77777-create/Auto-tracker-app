import 'Models/vehicle.dart';

/// Возвращает транспортное средство для текущего выбора.
///
/// Если у пользователя уже есть активный выбор и он ещё существует в списке,
/// он сохраняется. Иначе используется транспорт по умолчанию, а затем — первый
/// доступный автомобиль. Если автомобилей нет, возвращается null.
Vehicle? resolveSelectedVehicle({
  required List<Vehicle> vehicles,
  required Vehicle? currentSelection,
  required Vehicle? defaultVehicle,
  bool preserveExistingSelection = true,
}) {
  Vehicle? findVehicleById(int? id) {
    if (id == null) {
      return null;
    }

    for (final vehicle in vehicles) {
      if (vehicle.id == id) {
        return vehicle;
      }
    }

    return null;
  }

  if (preserveExistingSelection && currentSelection != null) {
    final matchingVehicle = findVehicleById(currentSelection.id);
    if (matchingVehicle != null) {
      return matchingVehicle;
    }
  }

  final matchingDefaultVehicle = findVehicleById(defaultVehicle?.id);
  if (matchingDefaultVehicle != null) {
    return matchingDefaultVehicle;
  }

  return vehicles.isNotEmpty ? vehicles.first : null;
}
