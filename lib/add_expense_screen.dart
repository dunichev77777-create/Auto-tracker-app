import 'package:flutter/material.dart';
import 'database_service.dart';
import 'Models/expense.dart';
import 'Models/vehicle.dart';

/// Экран добавления новой записи или редактирования существующей.
class AddExpenseScreen extends StatefulWidget {
  /// Если передан объект [Expense], экран работает в режиме редактирования.
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  /// Контроллеры полей формы.
  final _amountController = TextEditingController();
  final _odometerController = TextEditingController();
  final _commentController = TextEditingController();
  final _litersController = TextEditingController();

  /// Доступные категории расходов из базы.
  List<ExpenseCategory> _categories = [];
  /// Доступные транспортные средства из базы.
  List<Vehicle> _vehicles = [];
  /// Текущая выбранная категория.
  ExpenseCategory? _selectedCategory;
  /// Текущее выбранное транспортное средство.
  Vehicle? _selectedVehicle;
  /// Дата записи, которую пользователь может изменить.
  DateTime _selectedDate = DateTime.now();
  /// Флаг загрузки данных перед отображением формы.
  bool _isLoading = true;

  /// Определяет, открыт ли экран в режиме редактирования.
  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    // Инициализация формы должна происходить сразу после создания виджета.
    // Здесь загружаются категории и, при необходимости, данные текущей записи.
    _loadInitialData();
  }

  /// Загружает категории из базы и заполняет форму значениями.
  /// В режиме редактирования подставляются данные существующей записи,
  /// в режиме создания — выбирается категория по умолчанию и берётся последний пробег.
  Future<void> _loadInitialData() async {
    final categories = await DatabaseService.getAllCategories();
    final vehicles = await DatabaseService.getAllVehicles();
    final defaultVehicle = await DatabaseService.getDefaultVehicle();
    
    if (_isEditing) {
      // Режим РЕДАКТИРОВАНИЯ: заполняем поля данными из переданного расхода
      final currentExpense = widget.expense!;
      _amountController.text = currentExpense.amount.toString();
      _odometerController.text = currentExpense.odometer.toString();
      _commentController.text = currentExpense.comment ?? '';
      _litersController.text = currentExpense.liters?.toString() ?? '';
      
      // Загружаем привязанную категорию
      if (!currentExpense.category.isLoaded) {
        await currentExpense.category.load();
      }
      if (!currentExpense.vehicle.isLoaded) {
        await currentExpense.vehicle.load();
      }

      setState(() {
        _categories = categories;
        _vehicles = vehicles;
        _selectedCategory = categories.firstWhere(
          (c) => c.id == currentExpense.category.value?.id,
          orElse: () => categories.first,
        );
        _selectedVehicle = vehicles.firstWhere(
          (vehicle) => vehicle.id == currentExpense.vehicle.value?.id,
          orElse: () => vehicles.isNotEmpty ? vehicles.first : Vehicle(),
        );
        _selectedDate = currentExpense.date;
        _isLoading = false;
      });
    } else {
      // Режим СОЗДАНИЯ: подтягиваем последний пробег
      final lastOdometer = await DatabaseService.getLastOdometer();
      setState(() {
        _categories = categories;
        _vehicles = vehicles;
        _selectedVehicle = vehicles.firstWhere(
          (vehicle) => vehicle.id == defaultVehicle?.id,
          orElse: () => vehicles.isNotEmpty ? vehicles.first : Vehicle(),
        );
        _selectedCategory = categories.firstWhere(
          (c) => c.name == 'Заправка',
          orElse: () => categories.isNotEmpty ? categories.first : ExpenseCategory(),
        );
        if (lastOdometer > 0) {
          _odometerController.text = lastOdometer.toString();
        }
        _selectedDate = DateTime.now();
        _isLoading = false;
      });
    }
  }

  /// Открывает календарь и сохраняет выбранную дату в состояние формы.
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDate.hour,
          _selectedDate.minute,
          _selectedDate.second,
          _selectedDate.millisecond,
          _selectedDate.microsecond,
        );
      });
    }
  }

  /// Удаляет текущую запись из базы только в режиме редактирования.
  /// После удаления экран закрывается и пользователь возвращается к истории.
  Future<void> _deleteExpense() async {
    if (_isEditing) {
      await DatabaseService.deleteExpense(widget.expense!.id);
      if (mounted) {
        Navigator.pop(context); // Возвращаемся на главный экран
      }
    }
  }

  /// Открывает диалог добавления новой категории расхода.
  /// После сохранения категории список обновляется и новая категория сразу становится доступной.
  Future<void> _showAddCategoryDialog() async {
    final dialogController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая категория'),
        content: TextField(
          controller: dialogController,
          decoration: const InputDecoration(hintText: 'Например: Отражатель, Мойка'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final name = dialogController.text.trim();
              if (name.isNotEmpty) {
                await DatabaseService.addCategory(name);
                final updatedCategories = await DatabaseService.getAllCategories();
                setState(() {
                  _categories = updatedCategories;
                  _selectedCategory = updatedCategories.firstWhere((c) => c.name == name);
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Освобождаем все контроллеры ввода, чтобы избежать утечек памяти.
    _amountController.dispose();
    _odometerController.dispose();
    _commentController.dispose();
    _litersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Пока данные ещё не загружены, показываем экран загрузки,
    // чтобы пользователь не видел пустую форму.
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Редактирование' : 'Новая запись')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактирование записи' : 'Новая запись'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          // Если мы редактируем, показываем кнопку удаления в AppBar
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {
                // Подтверждение удаления
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Удалить запись?'),
                    content: const Text('Вы уверены, что хотите безвозвратно удалить это событие?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteExpense();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Удалить'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Основной контейнер формы с полями ввода.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Блок выбора категории и кнопки добавления новой категории.
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ExpenseCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Категория расхода'),
                    items: _categories.map((ExpenseCategory cat) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: cat,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (ExpenseCategory? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueGrey, size: 30),
                  onPressed: _showAddCategoryDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Выбор транспортного средства для текущей записи.
            DropdownButtonFormField<Vehicle>(
              initialValue: _selectedVehicle,
              decoration: const InputDecoration(labelText: 'Транспортное средство'),
              items: _vehicles.map((Vehicle vehicle) {
                return DropdownMenuItem<Vehicle>(
                  value: vehicle,
                  child: Text(vehicle.plate != null && vehicle.plate!.isNotEmpty ? '${vehicle.name} • ${vehicle.plate}' : vehicle.name),
                );
              }).toList(),
              onChanged: (Vehicle? newValue) {
                setState(() {
                  _selectedVehicle = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Для топлива показываем отдельное поле количества литров.
            if (_selectedCategory?.name == 'Заправка') ...[
              TextField(
                controller: _litersController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Количество литров (л)',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Основные поля записи: сумма, пробег и дата.
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Сумма (руб.)',
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _odometerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Текущий пробег (км)',
                prefixIcon: Icon(Icons.speed),
              ),
            ),
            const SizedBox(height: 16),

            // Поле выбора даты записи, открывающее календарь.
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Дата записи',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Поле для дополнительного комментария.
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                prefixIcon: Icon(Icons.comment),
              ),
            ),
            const SizedBox(height: 32),

            // Кнопка сохранения записи в базу.
            ElevatedButton(
              onPressed: () async {
                final amountText = _amountController.text;
                final odometerText = _odometerController.text;
                
                if (amountText.isEmpty || odometerText.isEmpty || _selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пожалуйста, заполните Сумму и Пробег')),
                  );
                  return;
                }

                // Если редактируем — сохраняем старый ID, иначе Isar сгенерирует автоинкремент
                final expense = _isEditing ? widget.expense! : Expense();
                expense.date = _selectedDate;

                expense
                  ..amount = double.parse(amountText)
                  ..odometer = int.parse(odometerText)
                  ..liters = _litersController.text.isEmpty ? null : double.parse(_litersController.text)
                  ..comment = _commentController.text.isEmpty ? null : _commentController.text;

                expense.category.value = _selectedCategory;
                if (_selectedVehicle != null) {
                  expense.vehicle.value = _selectedVehicle;
                }

                await DatabaseService.saveExpense(expense);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_isEditing ? 'Сохранить изменения' : 'Сохранить', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}