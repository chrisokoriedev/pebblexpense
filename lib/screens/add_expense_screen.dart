import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  String _amountStr = '0';
  final _titleController = TextEditingController();
  String _selectedCategory = 'Other';
  final List<String> _categories = ['Food', 'Transport', 'Bills', 'Other'];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onNumpadTap(String value) {
    if (_amountStr.length > 10) return; // Prevent extremely large numbers
    
    setState(() {
      if (value == 'backspace') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (value == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr += '.';
        }
      } else {
        if (_amountStr == '0') {
          _amountStr = value;
        } else {
          // ensure only 2 decimal places max
          if (_amountStr.contains('.')) {
            final parts = _amountStr.split('.');
            if (parts.length > 1 && parts[1].length >= 2) {
              return;
            }
          }
          _amountStr += value;
        }
      }
    });
  }

  void _addQuickAmount(int amount) {
    setState(() {
      _amountStr = amount.toString();
    });
  }

  void _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }
    
    final amountNgn = double.tryParse(_amountStr) ?? 0.0;
    if (amountNgn <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final amountKobo = (amountNgn * 100).round();

      await ref.read(expenseListProvider.notifier).addExpense(
            title: title,
            amountKobo: amountKobo,
            category: _selectedCategory,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add expense: $e')),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Title Input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Expense Title',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 20, color: Colors.black38),
                        ),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    
                    // Amount Display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        '₦$_amountStr',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    
                    const Text(
                      'Enter amount',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    
                    // Category selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Quick chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [500, 1000, 5000, 10000, 15000].map((amount) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ActionChip(
                              label: Text('₦$amount'),
                              backgroundColor: const Color(0xFFF9F9F9),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              side: BorderSide.none,
                              onPressed: () => _addQuickAmount(amount),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Numpad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  _NumpadRow(['1', '2', '3'], _onNumpadTap),
                  const SizedBox(height: 16),
                  _NumpadRow(['4', '5', '6'], _onNumpadTap),
                  const SizedBox(height: 16),
                  _NumpadRow(['7', '8', '9'], _onNumpadTap),
                  const SizedBox(height: 16),
                  _NumpadRow(['.', '0', 'backspace'], _onNumpadTap),
                ],
              ),
            ),
            
            // Submit Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Save Expense', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumpadRow extends StatelessWidget {
  final List<String> keys;
  final Function(String) onTap;

  const _NumpadRow(this.keys, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) {
        return _NumpadKey(k, onTap);
      }).toList(),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  final String keyString;
  final Function(String) onTap;

  const _NumpadKey(this.keyString, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(keyString),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: keyString == 'backspace'
            ? const Icon(Icons.backspace_outlined, size: 24, color: Colors.black87)
            : Text(
                keyString,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
