import 'package:flutter/material.dart';
import 'database_service.dart';
import 'Models/vehicle.dart';

/// Экран управления транспортными средствами.
/// Позволяет добавлять, редактировать и выбирать основную машину.
class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final vehicles = await DatabaseService.getAllVehicles();
    if (!mounted) return;
    setState(() {
      _vehicles = vehicles;
      _isLoading = false;
    });
  }

  Future<void> _showAddDialog({Vehicle? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final plateController = TextEditingController(text: existing?.plate ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Новое транспортное средство' : 'Редактировать транспортное средство'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название'),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(labelText: 'Госномер (необязательно)'),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () async {
                final deleted = await DatabaseService.deleteVehicle(existing.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                if (!deleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Нельзя удалить последнее транспортное средство')),
                  );
                }
                _loadVehicles();
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }

              if (existing == null) {
                await DatabaseService.addVehicle(name, plateController.text);
              } else {
                await DatabaseService.updateVehicle(existing.id, name, plateController.text);
              }

              if (!context.mounted) return;
              Navigator.pop(context);
              _loadVehicles();
            },
            child: Text(existing == null ? 'Добавить' : 'Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Транспортные средства'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddDialog(),
            tooltip: 'Добавить транспорт',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
              ? const Center(child: Text('Пока нет транспортных средств'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _vehicles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: vehicle.isDefault ? Colors.blueGrey[900] : Colors.blueGrey[50],
                          foregroundColor: vehicle.isDefault ? Colors.white : Colors.blueGrey[900],
                          child: const Icon(Icons.directions_car),
                        ),
                        title: Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? vehicle.plate! : 'Без госномера'),
                        trailing: IconButton(
                          icon: Icon(vehicle.isDefault ? Icons.star : Icons.star_border, color: Colors.amber),
                          onPressed: () async {
                            await DatabaseService.setDefaultVehicle(vehicle.id);
                            _loadVehicles();
                          },
                        ),
                        onTap: () => _showAddDialog(existing: vehicle),
                      ),
                    );
                  },
                ),
    );
  }
}
