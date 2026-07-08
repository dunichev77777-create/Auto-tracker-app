import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycar/Models/maintenance_setting.dart';
import 'package:mycar/Models/vehicle.dart';
import 'package:mycar/database_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return 'test_dir';
        }
        throw UnimplementedError();
      },
    );
  });

  test('getAllMaintenanceSettings filters by selected vehicle only', () async {
    await DatabaseService.init();

    await DatabaseService.isar.writeTxn(() async {
      await DatabaseService.isar.maintenanceSettings.clear();
      await DatabaseService.isar.vehicles.clear();
    });

    final carOne = Vehicle()..name = 'Car 1'..isDefault = true;
    final carTwo = Vehicle()..name = 'Car 2'..isDefault = false;

    await DatabaseService.isar.writeTxn(() async {
      await DatabaseService.isar.vehicles.putAll([carOne, carTwo]);
    });

    final matchingRule = MaintenanceSetting()
      ..title = 'Oil'
      ..intervalKm = 10000
      ..lastChangedOdometer = 5000
      ..lastChangedDate = DateTime.now()
      ..showOnMainScreen = true
      ..vehicle.value = carTwo;

    final unassignedRule = MaintenanceSetting()
      ..title = 'Brake fluid'
      ..intervalKm = 20000
      ..lastChangedOdometer = 10000
      ..lastChangedDate = DateTime.now()
      ..showOnMainScreen = true;

    await DatabaseService.isar.writeTxn(() async {
      await DatabaseService.isar.maintenanceSettings.putAll([matchingRule, unassignedRule]);
    });

    final filtered = await DatabaseService.getAllMaintenanceSettings(vehicleId: carTwo.id);

    expect(filtered, hasLength(1));
    expect(filtered.first.title, 'Oil');
  });
}
