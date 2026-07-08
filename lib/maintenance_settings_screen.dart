import 'package:flutter/material.dart';
import 'database_service.dart';
import 'Models/maintenance_setting.dart';
import 'Models/vehicle.dart';
import 'vehicle_selection_helper.dart';

/// Экран настроек регламентов технического обслуживания.
/// Здесь пользователь может менять интервалы замены и пробег последней замены.
class MaintenanceSettingsScreen extends StatefulWidget {
  const MaintenanceSettingsScreen({super.key});

  @override
  State<MaintenanceSettingsScreen> createState() => _MaintenanceSettingsScreenState();
}

class _MaintenanceSettingsScreenState extends State<MaintenanceSettingsScreen> {
  /// Список правил обслуживания, загруженных из базы.
  List<MaintenanceSetting> _settings = [];
  /// Все доступные транспортные средства.
  List<Vehicle> _vehicles = [];
  /// Текущее выбранное транспортное средство для фильтрации правил.
  Vehicle? _selectedVehicle;
  /// Флаг, показывающий, идёт ли загрузка данных.
  bool _isLoading = true;
  /// Сообщение об ошибке при сохранении.
  String? _errorMessage;

  /// Инициализация состояния виджета.
  /// При открытии экрана сразу загружаем актуальные настройки из базы.
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Загружает список правил обслуживания из сервиса базы данных.
  /// Обновляет состояние экрана с актуальными данными.
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final vehicles = await DatabaseService.getAllVehicles();
      final defaultVehicle = await DatabaseService.getDefaultVehicle();
      final data = await DatabaseService.getAllMaintenanceSettings(
        vehicleId: _selectedVehicle?.id,
      );
      if (!mounted) return;

      setState(() {
        _vehicles = vehicles;
        _selectedVehicle = _selectedVehicle == null
            ? null
            : resolveSelectedVehicle(
                vehicles: vehicles,
                currentSelection: _selectedVehicle,
                defaultVehicle: defaultVehicle,
              );
        _settings = data;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить настройки ТО: $error')),
      );
      setState(() {
        _settings = [];
        _vehicles = [];
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Показывает диалог создания нового правила обслуживания.
  /// Пользователь может ввести название, интервал замены, пробег последней замены и выбрать транспортное средство.
  Future<void> _showAddDialog() async {
    final titleController = TextEditingController();
    final intervalController = TextEditingController();
    final lastChangedController = TextEditingController();
    Vehicle? addVehicle = _vehicles.isNotEmpty ? _vehicles.first : null;

    // Показываем диалоговое окно с формой для создания нового правила
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Новое правило ТО'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Название',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: intervalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Интервал замены (км)',
                        prefixIcon: Icon(Icons.loop),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lastChangedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Пробег последней замены (км)',
                        prefixIcon: Icon(Icons.speed),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Vehicle>(
                      value: addVehicle,
                      decoration: const InputDecoration(
                        labelText: 'Транспорт',
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      items: _vehicles.map((Vehicle vehicle) {
                        return DropdownMenuItem<Vehicle>(
                          value: vehicle,
                          child: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? '${vehicle.name} • ${vehicle.plate}' : vehicle.name),
                        );
                      }).toList(),
                      onChanged: (Vehicle? value) {
                        setDialogState(() {
                          addVehicle = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Кнопка отмены создания правила
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                    const SizedBox(width: 8),
                    // Кнопка подтверждения создания правила
                    ElevatedButton(
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final interval = int.tryParse(intervalController.text);
                        final lastChanged = int.tryParse(lastChangedController.text);

                        if (title.isEmpty || interval == null || lastChanged == null) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Заполните все поля корректно')),
                          );
                          return;
                        }

                        try {
                          final newSetting = MaintenanceSetting()
                            ..title = title
                            ..intervalKm = interval
                            ..lastChangedOdometer = lastChanged
                            ..lastChangedDate = DateTime.now()
                            ..showOnMainScreen = true;

                          final added = await DatabaseService.addMaintenanceSetting(
                            newSetting,
                            vehicleId: addVehicle?.id,
                          );
                          if (!context.mounted) return;
                          if (!added) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Не удалось сохранить правило ТО')),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          await _loadSettings();
                        } catch (error) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка при создании правила ТО: $error')),
                          );
                        }
                      },
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Показывает диалог редактирования одного правила обслуживания.
  /// Пользователь может изменить интервал замены, пробег последней замены и привязку к транспортному средству.
  /// Также позволяет удалить правило, если оно не является системным.
  void _showEditDialog(MaintenanceSetting setting) {
    final intervalController = TextEditingController(text: setting.intervalKm.toString());
    final lastChangedController = TextEditingController(text: setting.lastChangedOdometer.toString());
    Vehicle? selectedVehicle = _vehicles.isNotEmpty
        ? _vehicles.firstWhere(
            (vehicle) => vehicle.id == setting.vehicleId,
            orElse: () => _vehicles.first,
          )
        : null;

    // Показываем диалоговое окно с формой для редактирования правила
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Регламент: ${setting.title}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: intervalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Интервал замены (км)',
                        prefixIcon: Icon(Icons.loop),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: lastChangedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Пробег последней замены (км)',
                        prefixIcon: Icon(Icons.speed),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Vehicle>(
                      value: selectedVehicle,
                      decoration: const InputDecoration(
                        labelText: 'Транспорт',
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      items: _vehicles.map((Vehicle vehicle) {
                        return DropdownMenuItem<Vehicle>(
                          value: vehicle,
                          child: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? '${vehicle.name} • ${vehicle.plate}' : vehicle.name),
                        );
                      }).toList(),
                      onChanged: (Vehicle? value) {
                        setDialogState(() {
                          selectedVehicle = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Кнопка удаления правила (показывается только для несистемных правил)
                    if (!setting.isSystem)
                      TextButton(
                        onPressed: () async {
                          await DatabaseService.deleteMaintenanceSetting(setting.id);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          _loadSettings();
                        },
                        child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(width: 8),
                    // Кнопка отмены редактирования
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                    const SizedBox(width: 8),
                    // Кнопка сохранения изменений
                    ElevatedButton(
                      onPressed: () async {
                        final interval = int.tryParse(intervalController.text) ?? setting.intervalKm;
                        final lastChanged = int.tryParse(lastChangedController.text) ?? setting.lastChangedOdometer;

                        await DatabaseService.updateMaintenanceSetting(
                          setting.id,
                          interval,
                          lastChanged,
                          showOnMainScreen: setting.showOnMainScreen,
                          vehicleId: selectedVehicle?.id,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _loadSettings();
                      },
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройка регламентов ТО'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          // Кнопка добавления нового правила ТО
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddDialog,
            tooltip: 'Добавить правило ТО',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: DropdownButtonFormField<Vehicle?>(
                    value: _selectedVehicle,
                    decoration: const InputDecoration(labelText: 'Транспорт для правил ТО'),
                    items: [
                      const DropdownMenuItem<Vehicle?>(value: null, child: Text('Все параметры')),
                      ..._vehicles.map((Vehicle vehicle) {
                        return DropdownMenuItem<Vehicle?>(
                          value: vehicle,
                          child: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? '${vehicle.name} • ${vehicle.plate}' : vehicle.name),
                        );
                      }),
                    ],
                    onChanged: (Vehicle? value) async {
                      setState(() => _selectedVehicle = value);
                      await _loadSettings();
                    },
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _settings.length,
                    itemBuilder: (context, index) {
                final setting = _settings[index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey[50],
                              foregroundColor: Colors.blueGrey[900],
                              child: const Icon(Icons.build_circle),
                            ),
                            title: Text(setting.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              'Интервал: ${setting.intervalKm} км\nПосл. замена: ${setting.lastChangedOdometer} км\nТС: ${setting.vehicleName}',
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Кнопка переключения отображения на главном экране (звезда)
                                IconButton(
                                  icon: Icon(
                                    setting.showOnMainScreen ? Icons.star : Icons.star_border,
                                    color: setting.showOnMainScreen ? Colors.amber : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    await DatabaseService.updateMaintenanceSetting(
                                      setting.id,
                                      setting.intervalKm,
                                      setting.lastChangedOdometer,
                                      showOnMainScreen: !setting.showOnMainScreen,
                                      vehicleId: setting.vehicleId,
                                    );
                                    _loadSettings();
                                  },
                                ),
                                // Иконка редактирования (нажатие на карточку также открывает редактирование)
                                const Icon(Icons.edit, color: Colors.blueGrey),
                              ],
                            ),
                            // При нажатии на карточку открываем диалог редактирования
                            onTap: () => _showEditDialog(setting),
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
    );
  }
}
