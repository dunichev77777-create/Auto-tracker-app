import 'package:flutter_test/flutter_test.dart';
import 'package:mycar/Models/maintenance_setting.dart';
import 'package:mycar/Models/vehicle.dart';

void main() {
  test('maintenance setting matches selected vehicle by vehicleId or linked vehicle', () {
    final vehicle = Vehicle()..id = 42;

    final byVehicleId = MaintenanceSetting()
      ..vehicleId = 42;

    final byLinkedVehicle = MaintenanceSetting();
    byLinkedVehicle.vehicle.value = vehicle;

    expect(byVehicleId.matchesVehicleId(42), isTrue);
    expect(byLinkedVehicle.matchesVehicleId(42), isTrue);
    expect(byLinkedVehicle.matchesVehicleId(7), isFalse);
  });
}
