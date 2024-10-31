import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/screens/aceitar_orcamento.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maos_a_obra/components/link.dart';

class OrcamentosPage extends StatefulWidget {
  @override
  _OrcamentosPageState createState() => _OrcamentosPageState();
}

class _OrcamentosPageState extends State<OrcamentosPage> {
  late Future<List<Orcamento>> _orcamentosFuture;

  @override
  void initState() {
    super.initState();
    _orcamentosFuture = fetchOrcamentos();
  }

  Future<List<Orcamento>> fetchOrcamentos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? role = prefs.getString('role');

    if (token == null || role == null) {
      throw Exception('Token ou Role não encontrado');
    }

    String apiUrl;

    // Verifica o role para determinar a URL correta
    if (role == 'client') {
      apiUrl = '${Link.link}/orcamentos/solicitados';
    } else if (role == 'service_provider') {
      apiUrl = '${Link.link}/provider/orcamentos/received';
    } else {
      throw Exception('Role desconhecido');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => Orcamento.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar orçamentos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orçamentos"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Orcamento>>(
              future: _orcamentosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum orçamento encontrado'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final orcamento = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // Verifica se o papel do usuário é 'client' antes de navegar
                          SharedPreferences.getInstance().then((prefs) {
                            String? role = prefs.getString('role');
                            if (role == 'client') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AceitarOrcamentoPage(
                                      orcamentoId: orcamento.id!),
                                ),
                              ).then((_) {
                                setState(() {
                                  _orcamentosFuture = fetchOrcamentos();
                                });
                              });
                            }
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Orçamento ID: ${orcamento.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Descrição: ${orcamento.description}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Valor: R\$ ${orcamento.valor != null ? orcamento.valor!.toStringAsFixed(2) : 0.00}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Preço dos Materiais: R\$ ${orcamento.precoMateriais != null ? orcamento.precoMateriais!.toStringAsFixed(2) : 0.00}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Lista de Materiais: ${orcamento.listaMateriais}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${orcamento.status}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Data de Criação: ${orcamento.createdAt}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Visita Agendada: ${orcamento.visitSchedule}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (orcamento.photos!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fotos:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: orcamento.photos!.length,
                                          itemBuilder: (context, photoIndex) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Image.network(
                                                '${Link.link}/${orcamento.photos![photoIndex]}',
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Orcamento {
  int? id;
  String? description;
  double? valor;
  double? precoMateriais;
  String? status;
  String? createdAt;
  String? visitSchedule;
  String? listaMateriais;
  List<String>? photos;

  Orcamento({
    this.id,
    this.description,
    this.valor,
    this.precoMateriais,
    this.status,
    this.createdAt,
    this.visitSchedule,
    this.listaMateriais,
    this.photos,
  });

  factory Orcamento.fromJson(Map<String, dynamic> json) {
    return Orcamento(
      id: json['id'],
      description: json['description'],
      valor: json['valor'],
      precoMateriais: json['preco_materiais'],
      status: json['status'],
      createdAt: json['created_at'],
      visitSchedule: json['visit_schedule'],
      listaMateriais: json['lista_materiais'],
      photos: List<String>.from(json['photos']),
    );
  }
}
