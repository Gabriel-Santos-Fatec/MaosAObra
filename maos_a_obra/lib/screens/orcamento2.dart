import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:maos_a_obra/screens/imagem_completa.dart';

class OrcamentoPage extends StatefulWidget {
  const OrcamentoPage({super.key});

  @override
  State<OrcamentoPage> createState() => _OrcamentoPageState();
}

class _OrcamentoPageState extends State<OrcamentoPage> {
  final List<File> _imageFiles = []; // Lista para armazenar as imagens
  final TextEditingController _controller =
      TextEditingController(); // Controlador para o campo de texto

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _imageFiles.clear(); // Limpa a lista antes de adicionar novas imagens
      if (pickedImages != null) {
        _imageFiles.addAll(pickedImages.map((image) => File(image.path)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(55),
                    bottomRight: Radius.circular(55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Cor da sombra com opacidade
                      spreadRadius: 5, // Raio de expansão da sombra
                      blurRadius: 10, // Raio de desfoque da sombra
                      offset:
                          const Offset(0, 4), // Deslocamento da sombra (x, y)
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // Substitua pelo caminho da sua imagem
                        height: MediaQuery.of(context).size.height *
                            0.05, // Ajuste o tamanho conforme necessário
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Mãos à obra!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CorConstante.laranja,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  color: CorConstante.laranja,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Cor da sombra com opacidade
                      spreadRadius: 5, // Raio de expansão da sombra
                      blurRadius: 10, // Raio de desfoque da sombra
                      offset:
                          const Offset(0, 4), // Deslocamento da sombra (x, y)
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/filtro.png', // Substitua pelo caminho da sua imagem
                        width: MediaQuery.of(context).size.height *
                            0.08, // Ajuste o tamanho conforme necessário
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          'Orçamento',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Descreva o serviço\nnecessário",
                style: TextStyle(
                    color: CorConstante.azulClaro,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.width * 0.02,
                      0,
                      0),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    style: TextStyle(
                      color: CorConstante.cinzaEscuro,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Descrição:',
                      hintStyle: TextStyle(
                        color: CorConstante.cinza,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Adicione fotos do\nlocal do serviço",
                style: TextStyle(
                    color: CorConstante.azulClaro,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              _imageFiles.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                      child: InkWell(
                        onTap: _pickImages,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.add_a_photo,
                              size: 40, color: Colors.black),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageFiles.length,
                        itemBuilder: (context, imgIndex) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImageViewer(
                                    imageFiles: _imageFiles,
                                    initialIndex: imgIndex,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.file(_imageFiles[imgIndex]),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
