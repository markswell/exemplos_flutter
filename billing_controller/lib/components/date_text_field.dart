import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class DateTextField extends StatefulWidget {
  final TextEditingController controller;

  const DateTextField({super.key, required this.controller});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  late MaskedTextController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = MaskedTextController(
      mask: '00/00/0000',
      text: widget.controller.text,
    );
    _dateController.beforeChange = (String previous, String next) {
      widget.controller.text = next;
      return next.length <= 10;
    };
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Data (dd/MM/yyyy)',
        hintText: '31/12/2023',
        counterText: '',
      ),
      maxLength: 10,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Informe a data';
        if (!_isValidDate(value)) return 'Data inválida';
        return null;
      },
    );
  }

  bool _isValidDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (day < 1 || day > 31) return false;
      if (month < 1 || month > 12) return false;
      if (year < 1900 || year > 2100) return false;

      // Validação adicional para meses com 30 dias e fevereiro
      if (month == 4 || month == 6 || month == 9 || month == 11) {
        if (day > 30) return false;
      }

      if (month == 2) {
        final isLeapYear =
            (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
        if (isLeapYear) {
          if (day > 29) return false;
        } else {
          if (day > 28) return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
