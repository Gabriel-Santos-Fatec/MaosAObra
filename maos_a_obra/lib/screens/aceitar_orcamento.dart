import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maos_a_obra/components/link.dart';

class AceitarOrcamentoPage extends StatefulWidget {
  final int orcamentoId;

  AceitarOrcamentoPage({required this.orcamentoId});

  @override
  _AceitarOrcamentoPageState createState() => _AceitarOrcamentoPageState();
}

class _AceitarOrcamentoPageState extends State<AceitarOrcamentoPage> {
  Future<void> aceitarOrcamento() async {
    String apiUrl =
        '${Link.link}/orcamentos/${widget.orcamentoId}/resposta?aceitar=true';
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
        SnackBar(content: Text('Orçamento aceito com sucesso!')),
      );
      Navigator.pop(context); // Volta para a página anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha ao aceitar o orçamento: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aceitar Orçamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você tem certeza que deseja aceitar este orçamento?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: aceitarOrcamento,
              child: Text('Aceitar Orçamento'),
            ),
          ],
        ),
      ),
    );
  }
}
