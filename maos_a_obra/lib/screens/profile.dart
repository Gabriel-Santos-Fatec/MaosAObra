import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/componente_feed.dart';
import 'package:maos_a_obra/components/componente_profile.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/edicao_perfil.dart';
import 'package:maos_a_obra/screens/dados_usuarios.dart';
import 'package:maos_a_obra/screens/orcamento2.dart';
import 'package:maos_a_obra/screens/post.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final int id;
  final String user;

  const ProfilePage({
    super.key,
    required this.id,
    required this.user,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Post>> _postsFuture;
  late bool role = false;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
    print('Role value: ${widget.id}');
  }

  Future<List<Post>> fetchPosts() async {
    String apiUrl = '${Link.link}/posts/${widget.id}/posts';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    bool updatedRole = prefs.getString('role') == "client";
    setState(() {
      role = updatedRole;
    });

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: const BoxDecoration(
                    color: CorConstante.azulClaro,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 25, 16, 0),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.11,
                            backgroundImage: AssetImage(
                              'assets/images/house.png',
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 16, 0),
                          child: Text(
                            "widget.user",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 16, 0),
                          child: Text(
                            "widget.user",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.065,
                                backgroundImage: AssetImage(
                                  'assets/images/whats.png',
                                ),
                                backgroundColor: Colors.white,
                              ),
                              CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.065,
                                backgroundImage: AssetImage(
                                  'assets/images/instagram.png',
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 85, 16, 0),
                          child: Text(
                            "Ingressou em 2018",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CorConstante.azulClaro,
                                fontSize: 15),
                          ),
                        ),
                        role
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrcamentoPage(
                                              provider_id: widget.id,
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 8, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: CorConstante.azulClaro,
                                      border: Border.all(
                                        color: CorConstante.azulClaro,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Orçamento",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.clipboardCheck,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: CorConstante.azulClaro,
                              border: Border.all(
                                color: CorConstante.azulClaro,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Avaliações",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: 4.5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0, // Tamanho das estrelas
                                    unratedColor: Colors.white.withAlpha(
                                        50), // Cor da parte não preenchida da estrela
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No posts found'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ComponentProfile(
                            nome: post.title,
                            user: widget.user,
                            descricao: post.description,
                            fotos: post.photoUrls.map((url) {
                              return Link.link + url.substring(21);
                            }).toList(),
                            userFoto: post.userFoto.substring(21),
                            rating: 4.5,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
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
