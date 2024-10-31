import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MarcarVisitaPage extends StatefulWidget {
  final int orcamentoId;

  MarcarVisitaPage({required this.orcamentoId});

  @override
  _MarcarVisitaPageState createState() => _MarcarVisitaPageState();
}

class _MarcarVisitaPageState extends State<MarcarVisitaPage> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _materiaisController = TextEditingController();
  final TextEditingController _precoMateriaisController =
      TextEditingController();

  // Criação do formatter para a máscara
  final maskFormatter = MaskTextInputFormatter(
    mask: 'R\$ ##0.00',
    filter: {
      "#": RegExp(r'[0-9]'),
      "0": RegExp(r'[0-9]'),
    },
  );

  Future<void> marcarVisitaRealizada() async {
    String apiUrl =
        '${Link.link}/provider/orcamentos/${widget.orcamentoId}/marcar_visita_realizada';
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
        SnackBar(content: Text('Visita marcada como realizada!')),
      );
    } else {
      throw Exception('Failed to marcar visita');
    }
  }

  Future<void> adicionarDetalhes() async {
    String apiUrl =
        '${Link.link}/provider/orcamentos/${widget.orcamentoId}/detalhes';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "valor": double.parse(_valorController.text
            .replaceAll('R\$ ', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')),
        "lista_materiais": _materiaisController.text,
        "preco_materiais": double.parse(_precoMateriaisController.text
            .replaceAll('R\$ ', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Detalhes adicionados com sucesso!')),
      );
    } else {
      throw Exception('Failed to adicionar detalhes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marcar Visita Realizada"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valor Cobrado:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration:
                  InputDecoration(hintText: 'Digite o valor (ex: R\$ 100.00)'),
            ),
            SizedBox(height: 16),
            Text(
              'Lista de Materiais:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _materiaisController,
              decoration:
                  InputDecoration(hintText: 'Digite a lista de materiais'),
            ),
            SizedBox(height: 16),
            Text(
              'Preço dos Materiais:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _precoMateriaisController,
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(
                  hintText: 'Digite o preço dos materiais (ex: R\$ 50.00)'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    marcarVisitaRealizada();
                    adicionarDetalhes();
                  },
                  child: Text('Marcar Visita'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
