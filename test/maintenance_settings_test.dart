import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycar/Models/maintenance_setting.dart';
import 'package:mycar/database_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    final tempDir = await Directory.systemTemp.createTemp('mycar_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
  });

  test('adding maintenance setting persists', () async {
    await DatabaseService.init();

    final before = await DatabaseService.getAllMaintenanceSettings();
    final setting = MaintenanceSetting()
      ..title = 'Тестовое ТО'
      ..intervalKm = 5000
      ..lastChangedOdometer = 1000
      ..lastChangedDate = DateTime.now()
      ..showOnMainScreen = false;

    final added = await DatabaseService.addMaintenanceSetting(setting);
    expect(added, isTrue);

    final after = await DatabaseService.getAllMaintenanceSettings();
    expect(after.length, greaterThan(before.length));
    expect(after.any((item) => item.title == 'Тестовое ТО'), isTrue);
  });
}
