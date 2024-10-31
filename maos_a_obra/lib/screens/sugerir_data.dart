import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SugerirDataPage extends StatefulWidget {
  final int orcamentoId;

  SugerirDataPage({required this.orcamentoId});

  @override
  _SugerirDataPageState createState() => _SugerirDataPageState();
}

class _SugerirDataPageState extends State<SugerirDataPage> {
  late Future<Orcamento> _orcamentoFuture;
  String? selectedDateTime;

  @override
  void initState() {
    super.initState();
    _orcamentoFuture = fetchOrcamentoDetails(widget.orcamentoId);
  }

  Future<Orcamento> fetchOrcamentoDetails(int id) async {
    String apiUrl = '${Link.link}/orcamentos/$id';
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

  Future<void> suggestNewDate(String dateTime) async {
    String apiUrl =
        '${Link.link}/orcamentos/${widget.orcamentoId}/sugerir_data';
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
        'nova_data': dateTime,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data sugerida com sucesso!')),
      );
    } else {
      print(response.body);
      throw Exception('Failed to suggest new date');
    }
  }

  Future<void> acceptVisit() async {
    String apiUrl =
        '${Link.link}/orcamentos/${widget.orcamentoId}/aceitar_visita';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visita aceita com sucesso!')),
      );
    } else {
      throw Exception('Failed to accept visit');
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime fullDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          selectedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime);
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
                    'Status: ${orcamento.status}',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _selectDateTime,
                        child: Text('Escolher Data'),
                      ),
                      ElevatedButton(
                        onPressed: selectedDateTime != null
                            ? () => suggestNewDate(selectedDateTime!)
                            : null,
                        child: Text('Sugerir Data'),
                      ),
                      ElevatedButton(
                        onPressed: () => acceptVisit(),
                        child: Text('Aceitar Visita'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (selectedDateTime != null)
                    Text('Data sugerida: $selectedDateTime'),
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
  final String status;

  Orcamento({
    required this.id,
    required this.description,
    required this.photos,
    required this.status,
  });

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    return Orcamento(
      id: json['id'],
      description: json['description'],
      photos: List<String>.from(json['photos']),
      status: json['status'],
    );
  }
}
