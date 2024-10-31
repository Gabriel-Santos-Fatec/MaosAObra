import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmarOrcamentoPage extends StatefulWidget {
  final int orcamentoId;

  ConfirmarOrcamentoPage({required this.orcamentoId});

  @override
  _ConfirmarOrcamentoPageState createState() => _ConfirmarOrcamentoPageState();
}

class _ConfirmarOrcamentoPageState extends State<ConfirmarOrcamentoPage> {
  late Future<Orcamento> _orcamentoFuture;
  DateTime? _selectedDateTime; // Armazenar a data e hora selecionadas

  @override
  void initState() {
    super.initState();
    _orcamentoFuture = fetchOrcamentoDetails(widget.orcamentoId);
  }

  Future<Orcamento> fetchOrcamentoDetails(int id) async {
    String apiUrl = '${Link.link}/provider/orcamentos/$id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));
      return Orcamento.fromJson(jsonData);
    } else {
      throw Exception('Failed to load orcamento details');
    }
  }

  Future<void> respondOrcamento(bool isAccepted) async {
    String apiUrl =
        '${Link.link}/provider/orcamentos/${widget.orcamentoId}/respond';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'is_accepted': isAccepted.toString(),
        'visit_schedule': _selectedDateTime?.toIso8601String() ?? '',
        'reason': '',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(isAccepted ? 'Orçamento aceito!' : 'Orçamento recusado!')),
      );
      Navigator.pop(context); // Volta para a página anterior
    } else {
      throw Exception('Failed to respond to orcamento');
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Orçamento"),
      ),
      body: FutureBuilder<Orcamento>(
        future: _orcamentoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Orçamento não encontrado'));
          } else {
            final orcamento = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orcamento.description,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orcamento.photos.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            '${Link.link}/${orcamento.photos[index]}',
                            width: 100,
                            height: 100,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedDateTime != null
                        ? 'Data e hora selecionadas: ${_selectedDateTime!.toLocal().day.toString().padLeft(2, '0')}/${_selectedDateTime!.toLocal().month.toString().padLeft(2, '0')}/${_selectedDateTime!.toLocal().year} ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                        : 'Nenhuma data e hora selecionadas',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _selectDateTime(context),
                    child: Text('Selecionar Data e Hora'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => respondOrcamento(true),
                        child: Text('Aceitar'),
                      ),
                      ElevatedButton(
                        onPressed: () => respondOrcamento(false),
                        child: Text('Recusar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class Orcamento {
  final int id;
  final String description;
  final List<String> photos;

  Orcamento({
    required this.id,
    required this.description,
    required this.photos,
  });

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    return Orcamento(
      id: json['id'],
      description: json['description'],
      photos: List<String>.from(json['photos']),
    );
  }
}
