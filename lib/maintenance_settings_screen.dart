import 'package:flutter/material.dart';
import 'database_service.dart';
import 'Models/maintenance_setting.dart';

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
  /// Флаг, показывающий, идёт ли загрузка данных.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // При открытии экрана сразу загружаем актуальные настройки из базы.
    _loadSettings();
  }

  /// Загружает список правил обслуживания из сервиса базы данных.
  Future<void> _loadSettings() async {
    final data = await DatabaseService.getAllMaintenanceSettings();
    if (!mounted) return;

    setState(() {
      _settings = data;
      _isLoading = false;
    });
  }

  /// Показывает диалог создания нового правила обслуживания.
  Future<void> _showAddDialog() async {
    final titleController = TextEditingController();
    final intervalController = TextEditingController();
    final lastChangedController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новое правило ТО'),
        content: Column(
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
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
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

              final newSetting = MaintenanceSetting()
                ..title = title
                ..intervalKm = interval
                ..lastChangedOdometer = lastChanged
                ..lastChangedDate = DateTime.now()
                ..showOnMainScreen = false;

              await DatabaseService.addMaintenanceSetting(newSetting);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadSettings();
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  /// Показывает диалог редактирования одного правила обслуживания.
  /// Пользователь может изменить интервал и пробег последней замены.
  void _showEditDialog(MaintenanceSetting setting) {
    final intervalController = TextEditingController(text: setting.intervalKm.toString());
    final lastChangedController = TextEditingController(text: setting.lastChangedOdometer.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Регламент: ${setting.title}'),
        content: Column(
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
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final interval = int.tryParse(intervalController.text) ?? setting.intervalKm;
              final lastChanged = int.tryParse(lastChangedController.text) ?? setting.lastChangedOdometer;

              await DatabaseService.updateMaintenanceSetting(setting.id, interval, lastChanged, showOnMainScreen: setting.showOnMainScreen);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadSettings();
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
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
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddDialog,
            tooltip: 'Добавить правило ТО',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                      'Интервал: ${setting.intervalKm} км\nПосл. замена: ${setting.lastChangedOdometer} км',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                            );
                            _loadSettings();
                          },
                        ),
                        const Icon(Icons.edit, color: Colors.blueGrey),
                      ],
                    ),
                    onTap: () => _showEditDialog(setting),
                  ),
                );
              },
            ),
    );
  }
}
