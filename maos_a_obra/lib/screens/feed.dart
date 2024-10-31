import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/componente_feed.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/edicao_perfil.dart';
import 'package:maos_a_obra/screens/dados_usuarios.dart';
import 'package:maos_a_obra/screens/notificacao.dart';
import 'package:maos_a_obra/screens/orcamento_todos.dart';
import 'package:maos_a_obra/screens/ordens_servico.dart';
import 'package:maos_a_obra/screens/post.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Post>> _postsFuture;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
    fetchNotifications(); // Fetch notifications when the page initializes
  }

  Future<List<Post>> fetchPosts() async {
    const String apiUrl = '${Link.link}/posts/?skip=0&limit=30';
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
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> fetchNotifications() async {
    const String apiUrl = '${Link.link}/notificacoes/';
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
      // Decodifica o corpo da resposta
      List<dynamic> jsonData = json.decode(response.body);

      // Contar o número total de itens na resposta
      int notificationCount = jsonData.length;

      // Atualiza o estado com o número total de notificações
      setState(() {
        _notificationCount = notificationCount;
      });
    } else {
      print('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificacaoPage()),
              ).then((_) {
                // Atualizar notificações ao retornar
                setState(() {
                  fetchNotifications();
                });
              });
            },
            child: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  size: 30,
                ),
                if (_notificationCount >
                    0) // Show badge only if there are notifications
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$_notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: CorConstante.azulClaro,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: CorConstante.azulClaro),
              title: Text('Settings',
                  style: TextStyle(color: CorConstante.azulClaro)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EdicaoPerfilPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: CorConstante.azulClaro),
              title: Text('Dados',
                  style: TextStyle(color: CorConstante.azulClaro)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DadosUsuarios()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: CorConstante.azulClaro),
              title:
                  Text('Post', style: TextStyle(color: CorConstante.azulClaro)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostExamplePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: CorConstante.azulClaro),
              title: Text('Ordens',
                  style: TextStyle(color: CorConstante.azulClaro)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdemServicoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: CorConstante.azulClaro),
              title: Text('Orçamentos',
                  style: TextStyle(color: CorConstante.azulClaro)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrcamentosPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: ComponentFeed(
                    ownerId: post.ownerId,
                    nome: post.title,
                    user: post.ownerName,
                    descricao: post.description,
                    fotos: post.photoUrls.map((url) {
                      return Link.link + url.substring(21);
                    }).toList(),
                    userFoto: post.userFoto.substring(21),
                    rating: 4.5,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Post {
  final int id;
  final String title;
  final String description;
  final int ownerId;
  final String ownerName;
  final List<String> photoUrls;
  final String userFoto;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.photoUrls,
    required this.userFoto,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ownerId: json['owner_id'],
      ownerName: json['owner_full_name'],
      userFoto: json['owner_photo'],
      photoUrls: List<String>.from(json['photo_urls']),
    );
  }
}
