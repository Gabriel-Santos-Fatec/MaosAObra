import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/confirmar_orcamento.dart';
import 'package:maos_a_obra/screens/sugerir_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TodasNotificacoesPage extends StatefulWidget {
  @override
  _TodasNotificacoesPageState createState() => _TodasNotificacoesPageState();
}

class _TodasNotificacoesPageState extends State<TodasNotificacoesPage> {
  late Future<Map<String, List<Notificacao>>> _notificacoesFuture;

  @override
  void initState() {
    super.initState();
    _notificacoesFuture = fetchNotificacoes();
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

  Future<Map<String, List<Notificacao>>> fetchNotificacoes() async {
    const String apiUrl = '${Link.link}/notificacoes/all';
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
      // Decodifica a resposta JSON como Map
      Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));

      // Verifica se as chaves 'nao_lidas' e 'lidas' existem e são listas
      List<Notificacao> naoLidas = (jsonData['nao_lidas'] as List)
          .map((item) => Notificacao.fromJson(item))
          .toList();

      List<Notificacao> lidas = (jsonData['lidas'] as List)
          .map((item) => Notificacao.fromJson(item))
          .toList();

      // Retorna as listas de notificações
      return {
        'nao_lidas': naoLidas,
        'lidas': lidas,
      };
    } else {
      throw Exception('Failed to load notificacoes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todas as Notificações"),
      ),
      body: FutureBuilder<Map<String, List<Notificacao>>>(
        future: _notificacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No notifications found'));
          } else {
            final naoLidas = snapshot.data!['nao_lidas']!;
            final lidas = snapshot.data!['lidas']!;

            return ListView(
              children: [
                // Seção de Notificações Não Lidas
                if (naoLidas.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Não Lidas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap:
                        true, // Para ajustar o tamanho da lista ao conteúdo
                    physics:
                        NeverScrollableScrollPhysics(), // Desativa o scroll aninhado
                    itemCount: naoLidas.length,
                    itemBuilder: (context, index) {
                      final notificacao = naoLidas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmarOrcamentoPage(
                                    orcamentoId: notificacao.orcamentoId!,
                                  ),
                                ),
                              );
                            },
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
                  ),
                ],

                // Seção de Notificações Lidas
                if (lidas.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Lidas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lidas.length,
                    itemBuilder: (context, index) {
                      final notificacao = lidas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              // Marcar a notificação como lida
                              await marcarNotificacaoComoLida(notificacao.id!);

                              // Após marcar, navegar para a página de confirmação do orçamento
                              notificacao.type == "visita_pendente_confirmacao"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SugerirDataPage(
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
                  ),
                ],
              ],
            );
          }
        },
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
