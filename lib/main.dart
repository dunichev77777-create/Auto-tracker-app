import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'add_expense_screen.dart';
import 'database_service.dart';
import 'Models/expense.dart';
import 'Models/maintenance_setting.dart';
import 'Models/vehicle.dart';
import 'package:intl/intl.dart';
import 'analytics_screen.dart';
import 'maintenance_settings_screen.dart';
import 'reference_items_screen.dart';
import 'vehicle_management_screen.dart';
import 'vehicle_selection_helper.dart';

/// Точка входа приложения.
/// Инициализирует базу данных и запускает корневой виджет.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(const MyCarApp());
}

/// Корневой виджет приложения с темой и стартовым экраном.
class MyCarApp extends StatelessWidget {
  const MyCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto tracker',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

/// Основной экран приложения с общей статистикой, ТО и историей расходов.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isInitializing = true;
  Vehicle? _selectedVehicle;
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await DatabaseService.init();
    final vehicles = await DatabaseService.getAllVehicles();
    final defaultVehicle = await DatabaseService.getDefaultVehicle();
    if (!mounted) return;
    setState(() {
      _vehicles = vehicles;
      _selectedVehicle = resolveSelectedVehicle(
        vehicles: vehicles,
        currentSelection: _selectedVehicle,
        defaultVehicle: defaultVehicle,
      );
      _isInitializing = false;
    });
  }

  /// Перерисовывает экран после возврата с дочернего экрана.
  Future<void> _refreshData() async {
    final vehicles = await DatabaseService.getAllVehicles();
    final defaultVehicle = await DatabaseService.getDefaultVehicle();
    if (!mounted) return;
    setState(() {
      _vehicles = vehicles;
      _selectedVehicle = resolveSelectedVehicle(
        vehicles: vehicles,
        currentSelection: _selectedVehicle,
        defaultVehicle: defaultVehicle,
      );
    });
  }

  /// Формирует карточку элемента обслуживания ТО.
  /// Показывает название задачи, сколько километров осталось до следующего обслуживания
  /// и прогресс в виде индикатора состояния.
  Widget _buildMaintenanceItem(String title, int remainingKm, int maxInterval) {
    final double progress = (remainingKm / maxInterval).clamp(0.0, 1.0);
    final Color progressColor = progress < 0.2 ? Colors.redAccent : (progress < 0.5 ? Colors.orange : Colors.green);

    return Container(
      width: 145, // Чуть расширили под длинные слова
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10), // Оптимизировали внутренние паддинги
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                remainingKm <= 0 ? 'Заменить!' : '$remainingKm км',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: progressColor),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: progressColor,
                minHeight: 5,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // Главный экран объединяет в себе общую аналитику, блок ТО и историю расходов.
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('mycar', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.directions_car, color: Colors.white, size: 36),
                  SizedBox(height: 8),
                  Text('mycar', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Управление расходами и ТО', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Аналитика'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsScreen()));
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_circle_outlined),
              title: const Text('Регламенты ТО'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const MaintenanceSettingsScreen()));
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car_outlined),
              title: const Text('Транспортные средства'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleManagementScreen()));
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmarks_outlined),
              title: const Text('Справочные элементы'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferenceItemsScreen()));
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Справка'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Справка'),
                    content: const Text(
                      '• Добавляйте расходы и события из кнопки +\n'
                      '• Используйте аналитику для просмотра трат по периодам\n'
                      '• Настраивайте регламенты ТО и добавляйте свои правила',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Expense>>(
        future: DatabaseService.getAllExpenses(),
        builder: (context, expenseSnapshot) {
          if (expenseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = expenseSnapshot.data ?? [];
          final filteredExpenses = _selectedVehicle == null
              ? expenses
              : expenses.where((expense) => expense.vehicle.value?.id == _selectedVehicle!.id).toList();
          final totalExpenses = filteredExpenses.fold<double>(0.0, (sum, item) => sum + item.amount);
          
          final currentOdometer = filteredExpenses.isNotEmpty 
              ? filteredExpenses.map((e) => e.odometer).reduce((a, b) => a > b ? a : b) 
              : 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Vehicle?>(
                        initialValue: _selectedVehicle,
                        decoration: const InputDecoration(labelText: 'Транспорт'),
                        items: [
                          const DropdownMenuItem<Vehicle?>(value: null, child: Text('Все')),
                          ..._vehicles.map((Vehicle vehicle) {
                            return DropdownMenuItem<Vehicle?>(
                              value: vehicle,
                              child: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? '${vehicle.name} • ${vehicle.plate}' : vehicle.name),
                            );
                          }),
                        ],
                        onChanged: (Vehicle? value) {
                          setState(() {
                            _selectedVehicle = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Виджет Общих Расходов
                InkWell(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsScreen()));
                    _refreshData();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Card(
                    elevation: 4,
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Общие расходы', style: TextStyle(fontSize: 16, color: Colors.grey)),
                              SizedBox(height: 5),
                              Text('За все время (Аналитика)', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                            ],
                          ),
                          Text(
                            '${totalExpenses.toStringAsFixed(1)} ₽',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Заголовок Мониторинга ТО с шестерёнкой настроек
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Мониторинг ТО', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.blueGrey),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MaintenanceSettingsScreen()),
                        );
                        _refreshData();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Динамический вывод регламентов ТО из базы Isar
                FutureBuilder<List<MaintenanceSetting>>(
                  future: DatabaseService.getAllMaintenanceSettings(),
                  builder: (context, settingsSnapshot) {
                    if (!settingsSnapshot.hasData) return const SizedBox(height: 110);
                    final settings = settingsSnapshot.data!.where((rule) => rule.showOnMainScreen).toList();

                    return SizedBox(
                      height: 110, // Увеличили высоту для безопасности
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: settings.length,
                        itemBuilder: (context, index) {
                          final rule = settings[index];
                          
                          // Формула: (Пробег_Посл_Замены + Интервал) - Текущий_Пробег
                          final int remaining = (rule.lastChangedOdometer + rule.intervalKm) - currentOdometer;
                          
                          return _buildMaintenanceItem(rule.title, remaining, rule.intervalKm);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                const Text('История событий', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Expanded(
                  child: filteredExpenses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car, size: 64, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                'Событий пока нет.\nНажмите "+", чтобы добавить заправку или ТО.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = filteredExpenses[index];
                            final categoryName = expense.category.value?.name ?? 'Без категории';
                            final vehicleName = expense.vehicle.value?.name ?? 'Транспорт';
                            final dateFormatted = DateFormat('dd.MM.yyyy').format(expense.date);

                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddExpenseScreen(expense: expense)),
                                );
                                _refreshData();
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                color: Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueGrey[50],
                                    foregroundColor: Colors.blueGrey[900],
                                    child: Icon(
                                      categoryName == 'Заправка'
                                          ? Icons.local_gas_station
                                          : (categoryName == 'ТО' ? Icons.build : Icons.payments),
                                    ),
                                  ),
                                  title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('$dateFormatted • ${expense.odometer} км • $vehicleName'),
                                  trailing: Text(
                                    '-${expense.amount.toStringAsFixed(1)} ₽',
                                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen()));
          _refreshData();
        },
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}