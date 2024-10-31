import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/ordens_servico.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class CompleteOrderPage extends StatefulWidget {
  final OrdemServico ordemServico;

  CompleteOrderPage({required this.ordemServico});

  @override
  _CompleteOrderPageState createState() => _CompleteOrderPageState();
}

class _CompleteOrderPageState extends State<CompleteOrderPage> {
  List<File> _selectedFiles = []; // Agora é uma lista de arquivos

  Future<void> _completeOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${Link.link}/provider/service-orders/${widget.ordemServico.id}/complete'),
    );

    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    // Adiciona todos os arquivos selecionados
    for (var file in _selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          file.path,
          contentType:
              MediaType('image', 'png'), // Alterar o tipo conforme necessário
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ordem completada com sucesso!')),
      );
      Navigator.pop(context); // Volta para a página anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao completar a ordem.')),
      );
    }
  }

  Future<void> _pickFiles() async {
    final picker = ImagePicker();
    final pickedFiles = await picker
        .pickMultiImage(); // Método para selecionar múltiplas imagens

    if (pickedFiles != null) {
      setState(() {
        _selectedFiles =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completar Ordem de Serviço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Data de Início: ${widget.ordemServico.startDate}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Status: ${widget.ordemServico.status}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            // Botão para selecionar arquivos
            TextButton(
              onPressed: _pickFiles,
              child: Text(
                _selectedFiles.isEmpty
                    ? 'Selecionar Arquivos'
                    : 'Arquivos Selecionados: ${_selectedFiles.length}',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedFiles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('O envio das fotos é obrigatório.')),
                  );
                } else {
                  _completeOrder();
                }
              },
              child: Text('Completar Ordem'),
            ),
          ],
        ),
      ),
    );
  }
}
