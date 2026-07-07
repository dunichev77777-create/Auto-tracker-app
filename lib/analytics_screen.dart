import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_service.dart';
import 'Models/vehicle.dart';
import 'vehicle_selection_helper.dart';

/// Экран аналитики расходов.
/// Показывает суммарные траты за выбранный период и распределение по категориям.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  /// Контроллер вкладок недели, месяца и года.
  late TabController _tabController;
  /// Суммы расходов по категориям для текущего периода.
  Map<String, double> _chartData = {};
  /// Текущий выбранный период.
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  /// Транспортное средство, по которому фильтруется аналитика.
  Vehicle? _selectedVehicle;
  List<Vehicle> _vehicles = [];
  /// Флаг загрузки данных аналитики.
  bool _isLoading = true;
  /// Общая сумма расходов за выбранный период.
  double _totalSum = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final vehicles = await DatabaseService.getAllVehicles();
    final defaultVehicle = await DatabaseService.getDefaultVehicle();
    setState(() {
      _vehicles = vehicles;
      _selectedVehicle = resolveSelectedVehicle(
        vehicles: vehicles,
        currentSelection: _selectedVehicle,
        defaultVehicle: defaultVehicle,
      );
    });
    await _loadAnalytics(0);
  }

  /// Перезагружает аналитику при смене вкладки.
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _loadAnalytics(_tabController.index);
    }
  }

  /// Загружает данные аналитики для выбранного периода: неделя, месяц или год.
  /// На выходе получает суммарные расходы по категориям и общую сумму за период.
  Future<void> _loadAnalytics(int tabIndex) async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    late DateTime startDate;

    switch (tabIndex) {
      case 0: // Неделя
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 1: // Месяц
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 2: // Год
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    _startDate = startDate;
    _endDate = now;

    final data = await DatabaseService.getAnalyticsForPeriod(startDate, now, vehicleId: _selectedVehicle?.id);
    final total = data.values.fold<double>(0.0, (sum, val) => sum + val);

    setState(() {
      _chartData = data;
      _totalSum = total;
      _isLoading = false;
    });
  }

  Future<void> _showCustomPeriodDialog() async {
    final pickedRange = DateTimeRange(start: _startDate, end: _endDate);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      initialDateRange: pickedRange,
      locale: const Locale('ru', 'RU'),
    );

    if (range != null) {
      if (!mounted) return;
      setState(() {
        _startDate = DateTime(range.start.year, range.start.month, range.start.day);
        _endDate = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);
      });
      await _loadAnalyticsForCustomRange();
    }
  }

  Future<void> _loadAnalyticsForCustomRange() async {
    setState(() => _isLoading = true);
    final data = await DatabaseService.getAnalyticsForPeriod(_startDate, _endDate, vehicleId: _selectedVehicle?.id);
    final total = data.values.fold<double>(0.0, (sum, val) => sum + val);
    setState(() {
      _chartData = data;
      _totalSum = total;
      _isLoading = false;
    });
  }

  /// Освобождает ресурсы контроллера вкладок.
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Аналитика расходов'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Выбрать период вручную',
            onPressed: _showCustomPeriodDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Неделя'),
            Tab(text: 'Месяц'),
            Tab(text: 'Год'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chartData.isEmpty
              ? const Center(
                  child: Text(
                    'Нет данных за выбранный период',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : Padding(
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
                              onChanged: (Vehicle? value) async {
                                setState(() => _selectedVehicle = value);
                                await _loadAnalyticsForCustomRange();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Период: ${DateFormat('dd.MM.yyyy').format(_startDate)} — ${DateFormat('dd.MM.yyyy').format(_endDate)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      // Суммарная карточка за период
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Итого потрачено:',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                              Text(
                                '${_totalSum.toStringAsFixed(1)} ₽',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Структура расходов',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      
                      // Список категорий с долями в процентах
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chartData.length,
                          itemBuilder: (context, index) {
                            final key = _chartData.keys.elementAt(index);
                            final amount = _chartData[key] ?? 0.0;
                            final percentage = _totalSum > 0 ? (amount / _totalSum) : 0.0;

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          key,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        Text(
                                          '${amount.toStringAsFixed(1)} ₽ (${(percentage * 100).toStringAsFixed(1)}%)',
                                          style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Красивый индикатор доли
                                    LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey[200],
                                      color: Colors.blueGrey[700],
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}