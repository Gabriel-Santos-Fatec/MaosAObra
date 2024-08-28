import 'package:flutter/material.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/imagem_completa_web.dart';
import 'package:maos_a_obra/screens/profile.dart';

class ComponentFeed extends StatefulWidget {
  final String nome;
  final String user;
  final String descricao;
  final List<String> fotos;
  final String? userFoto;
  final double rating;
  final int ownerId;

  const ComponentFeed({
    super.key,
    required this.nome,
    required this.user,
    required this.descricao,
    required this.fotos,
    this.userFoto,
    required this.rating,
    required this.ownerId,
  });

  @override
  _ComponentFeedState createState() => _ComponentFeedState();
}

class _ComponentFeedState extends State<ComponentFeed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: CorConstante.laranja,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                MediaQuery.of(context).size.width * 0.025,
                0,
                MediaQuery.of(context).size.width * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.065,
                          backgroundImage: NetworkImage(
                            "${Link.link}${widget.userFoto}",
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                                id: widget.ownerId,
                                                user: widget.user,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    widget.user,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.user,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.fotos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagemCompleta(
                                  imageUrls: widget.fotos.map((url) {
                                    return Link.link + url.substring(20);
                                  }).toList(),
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Define o raio das bordas
                              child: Image.network(
                                widget.fotos[index],
                                fit: BoxFit
                                    .fill, // Use BoxFit.cover para manter a proporção da imagem
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            color: CorConstante.laranja,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.width * 0.1,
              0,
              MediaQuery.of(context).size.width * 0.1,
            ),
            child: Text(
              "${widget.user}: ${widget.descricao}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
