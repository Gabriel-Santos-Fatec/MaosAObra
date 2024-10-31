import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/confirmar_orcamento.dart';
import 'package:maos_a_obra/screens/marcar_visita_realizada.dart';
import 'package:maos_a_obra/screens/notificacoes_todas.dart';
import 'package:maos_a_obra/screens/sugerir_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificacaoPage extends StatefulWidget {
  @override
  _NotificacaoPageState createState() => _NotificacaoPageState();
}

class _NotificacaoPageState extends State<NotificacaoPage> {
  late Future<List<Notificacao>> _notificacoesFuture;

  @override
  void initState() {
    super.initState();
    _notificacoesFuture = fetchNotificacoes();
  }

  Future<List<Notificacao>> fetchNotificacoes() async {
    const String apiUrl = '${Link.link}/notificacoes/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    print(token);
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decode the response using UTF-8
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((item) => Notificacao.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notificacoes');
    }
  }

  Future<void> marcarNotificacaoComoLida(int notificacaoId) async {
    final String apiUrl =
        '${Link.link}/notificacoes/$notificacaoId/marcar_como_lida';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Notificação marcada como lida');
    } else {
      print('Falha ao marcar notificação como lida');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Notificacao>>(
              future: _notificacoesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Você não possui notificações'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final notificacao = snapshot.data![index];
                      return InkWell(
                        onTap: () async {
                          // Marcar a notificação como lida
                          await marcarNotificacaoComoLida(notificacao.id!);

                          // Após marcar, navegar para a página de confirmação do orçamento
                          notificacao.type == "visita_pendente_confirmacao"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SugerirDataPage(
                                      orcamentoId: notificacao.orcamentoId ?? 0,
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _notificacoesFuture = fetchNotificacoes();
                                  });
                                })
                              : notificacao.type == "visita_agendada"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MarcarVisitaPage(
                                          orcamentoId:
                                              notificacao.orcamentoId ?? 0,
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        _notificacoesFuture =
                                            fetchNotificacoes();
                                      });
                                    })
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConfirmarOrcamentoPage(
                                          orcamentoId:
                                              notificacao.orcamentoId ?? 0,
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        _notificacoesFuture =
                                            fetchNotificacoes();
                                      });
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
                                  notificacao.message!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('dd/MM/yyyy HH:mm:ss').format(
                                      DateTime.parse(notificacao.createdAt!)),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tipo: ${notificacao.type}',
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
          // Botão para exibir todas as notificações
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodasNotificacoesPage(),
                  ),
                );
              },
              child: Text('Exibir todas as notificações'),
            ),
          ),
        ],
      ),
    );
  }
}

class Notificacao {
  int? id;
  String? message;
  int? orcamentoId;
  String? type;
  String? createdAt;

  Notificacao({
    this.id,
    this.message,
    this.orcamentoId,
    this.type,
    this.createdAt,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'],
      message: json['message'],
      orcamentoId: json['orcamento_id'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }
}
