import 'package:flutter/material.dart';
import 'database_service.dart';

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
  /// Флаг загрузки данных аналитики.
  bool _isLoading = true;
  /// Общая сумма расходов за выбранный период.
  double _totalSum = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadAnalytics(0); // По умолчанию загружаем Неделю
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

    final data = await DatabaseService.getAnalyticsForPeriod(startDate);
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