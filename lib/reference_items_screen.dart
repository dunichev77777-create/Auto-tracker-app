import 'package:flutter/material.dart';
import 'database_service.dart';
import 'Models/expense.dart';

/// Экран со справочными элементами приложения.
/// Сейчас здесь отображаются категории расходов, которые можно добавлять, редактировать и удалять.
class ReferenceItemsScreen extends StatefulWidget {
  const ReferenceItemsScreen({super.key});

  @override
  State<ReferenceItemsScreen> createState() => _ReferenceItemsScreenState();
}

class _ReferenceItemsScreenState extends State<ReferenceItemsScreen> {
  List<ExpenseCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await DatabaseService.getAllCategories();
    if (!mounted) return;

    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая справочная запись'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Название'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                if (!context.mounted) return;
                Navigator.pop(context);
                return;
              }

              await DatabaseService.addCategory(name);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadCategories();
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(ExpenseCategory category) async {
    final controller = TextEditingController(text: category.name);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать справочную запись'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Название'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          if (!category.isSystem)
            TextButton(
              onPressed: () async {
                await DatabaseService.deleteCategory(category.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                _loadCategories();
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) {
                if (!context.mounted) return;
                return;
              }

              await DatabaseService.updateCategory(category.id, name);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadCategories();
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
        title: const Text('Справочные элементы'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddDialog,
            tooltip: 'Добавить элемент',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(child: Text('Пока нет справочных элементов'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey[50],
                          foregroundColor: Colors.blueGrey[900],
                          child: const Icon(Icons.label_outline),
                        ),
                        title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(category.isSystem ? 'Системная запись' : 'Пользовательская запись'),
                        trailing: const Icon(Icons.edit, color: Colors.blueGrey),
                        onTap: () => _showEditDialog(category),
                      ),
                    );
                  },
                ),
    );
  }
}
