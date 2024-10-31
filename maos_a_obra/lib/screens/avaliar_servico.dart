import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/screens/ordens_servico.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maos_a_obra/components/link.dart';
import 'dart:convert'; // Para usar json.encode

class ReviewServicePage extends StatefulWidget {
  final OrdemServico ordemServico;

  ReviewServicePage({required this.ordemServico});

  @override
  _ReviewServicePageState createState() => _ReviewServicePageState();
}

class _ReviewServicePageState extends State<ReviewServicePage> {
  int _rating = 0; // Avaliação do cliente
  final TextEditingController _detailsController =
      TextEditingController(); // Controlador para o campo de detalhes

  Future<void> _submitRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    // Cria um mapa com os dados da avaliação
    Map<String, dynamic> ratingData = {
      'rating': _rating,
      'comment': _detailsController.text,
    };

    final response = await http.post(
      Uri.parse(
          '${Link.link}/client/service-orders/${widget.ordemServico.id}/evaluate'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // Define o tipo de conteúdo como JSON
      },
      body: json.encode(ratingData), // Converte o mapa em JSON
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Avaliação enviada com sucesso!')),
      );
      Navigator.pop(context); // Volta para a página anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar a avaliação.')),
      );
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          _rating = index; // Atualiza a avaliação
        });
      },
    );
  }

  @override
  void dispose() {
    _detailsController.dispose(); // Limpa o controlador ao dispensar a página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar Serviço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Avalie o Serviço',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) => _buildStar(index + 1)),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Detalhes da Avaliação',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_rating == 0 || _detailsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Por favor, selecione uma avaliação e escreva detalhes.'),
                    ),
                  );
                } else {
                  _submitRating();
                }
              },
              child: Text('Enviar Avaliação'),
            ),
          ],
        ),
      ),
    );
  }
}
