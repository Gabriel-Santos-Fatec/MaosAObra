import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/ordens_servico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetDeadlinePage extends StatefulWidget {
  final OrdemServico ordemServico;

  SetDeadlinePage({required this.ordemServico});

  @override
  _SetDeadlinePageState createState() => _SetDeadlinePageState();
}

class _SetDeadlinePageState extends State<SetDeadlinePage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _setDeadline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final String startDate = widget.ordemServico.startDate;
    final String deadline = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    ));

    final response = await http.post(
      Uri.parse(
          '${Link.link}/provider/service-orders/${widget.ordemServico.id}/set-deadline?start_date=$startDate&deadline=$deadline'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deadline definida com sucesso!')),
      );
      Navigator.pop(context); // Volta para a página anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao definir a deadline.')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Definir Deadline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exibe os dados da ordem de serviço
            Text(
              'Dados da Ordem de Serviço',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ordem de Serviço ID: ${widget.ordemServico.id}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Data de Início: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(widget.ordemServico.startDate))}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Status: ${widget.ordemServico.status}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Cliente Confirmou: ${widget.ordemServico.clientConfirmation ? "Sim" : "Não"}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Selecione a data
            Text(
              'Selecione a data:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _selectedDate == null
                    ? 'Escolher data'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              ),
            ),
            SizedBox(height: 16),
            // Selecione a hora
            Text(
              'Selecione a hora:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                _selectedTime == null
                    ? 'Escolher hora'
                    : _selectedTime!.format(context),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate != null && _selectedTime != null) {
                  _setDeadline();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Por favor, selecione data e hora.')),
                  );
                }
              },
              child: Text('Definir Deadline'),
            ),
          ],
        ),
      ),
    );
  }
}
