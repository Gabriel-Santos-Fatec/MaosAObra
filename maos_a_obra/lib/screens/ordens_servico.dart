import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/screens/avaliar_servico.dart';
import 'package:maos_a_obra/screens/dead_line.dart'; // Importa a página de definição de deadline
import 'package:maos_a_obra/screens/complete_order.dart'; // Importa a nova página para completar a ordem
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:maos_a_obra/components/link.dart';

class OrdemServicoPage extends StatefulWidget {
  @override
  _OrdemServicoPageState createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage> {
  late Future<List<OrdemServico>> _ordensServicoFuture;

  @override
  void initState() {
    super.initState();
    _ordensServicoFuture = fetchOrdensServico();
  }

  Future<List<OrdemServico>> fetchOrdensServico() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? role = prefs.getString('role');

    if (token == null || role == null) {
      throw Exception('Token ou Role não encontrado');
    }

    String apiUrl;

    // Verifica o role para determinar a URL correta
    if (role == 'client') {
      apiUrl = '${Link.link}/client/service-orders/';
    } else if (role == 'service_provider') {
      apiUrl = '${Link.link}/provider/service-orders/';
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
      return jsonData.map((item) => OrdemServico.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar ordens de serviço');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ordens de Serviço"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<OrdemServico>>(
              future: _ordensServicoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma ordem de serviço encontrada'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ordemServico = snapshot.data![index];
                      return GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? role = prefs.getString('role');

                          if (ordemServico.status == 'COMPLETED' &&
                              role == 'client') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewServicePage(
                                    ordemServico: ordemServico),
                              ),
                            ).then((_) {
                              // Atualizar notificações ao retornar
                              setState(() {
                                fetchOrdensServico();
                              });
                            });
                          }
                          if (ordemServico.status == 'IN_PROGRESS' &&
                              role == 'service_provider') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompleteOrderPage(
                                      ordemServico: ordemServico),
                                )).then((_) {
                              // Atualizar notificações ao retornar
                              setState(() {
                                fetchOrdensServico();
                              });
                            });
                          } else if (ordemServico.status == 'PENDING' &&
                              role == 'service_provider') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SetDeadlinePage(
                                      ordemServico: ordemServico),
                                )).then((_) {
                              // Atualizar notificações ao retornar
                              setState(() {
                                fetchOrdensServico();
                              });
                            });
                          } else {}
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
                                  'Ordem de Serviço ID: ${ordemServico.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Data de Início: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(ordemServico.startDate))}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${ordemServico.status}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Cliente Confirmou: ${ordemServico.clientConfirmation ? "Sim" : "Não"}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Adiciona a linha para mostrar a deadline
                                Text(
                                  'Deadline: ${ordemServico.deadline ?? "Não definida"}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
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

class OrdemServico {
  final int id;
  final int budgetId;
  final int clientId;
  final int providerId;
  final String startDate;
  final String? deadline;
  final String status;
  final String createdAt;
  final bool clientConfirmation;
  final String? providerDeadlineProposed;

  OrdemServico({
    required this.id,
    required this.budgetId,
    required this.clientId,
    required this.providerId,
    required this.startDate,
    required this.deadline,
    required this.status,
    required this.createdAt,
    required this.clientConfirmation,
    required this.providerDeadlineProposed,
  });

  factory OrdemServico.fromJson(Map<String, dynamic> json) {
    return OrdemServico(
      id: json['id'],
      budgetId: json['budget_id'],
      clientId: json['client_id'],
      providerId: json['provider_id'],
      startDate: json['start_date'],
      deadline: json['deadline'],
      status: json['status'],
      createdAt: json['created_at'],
      clientConfirmation: json['client_confirmation'],
      providerDeadlineProposed: json['provider_deadline_proposed'],
    );
  }
}
