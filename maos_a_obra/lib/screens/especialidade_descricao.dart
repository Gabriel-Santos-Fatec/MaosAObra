import 'package:flutter/material.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:maos_a_obra/screens/imagem_completa.dart';

class EspecialidadeDescricao extends StatefulWidget {
  const EspecialidadeDescricao({super.key});

  @override
  State<EspecialidadeDescricao> createState() => _EspecialidadeDescricaoState();
}

class _EspecialidadeDescricaoState extends State<EspecialidadeDescricao> {
  final List<ImageDescriptionBlock> _blocks = [ImageDescriptionBlock()];
  final List<TextEditingController> _controllers = [TextEditingController()];

  Future<void> _pickImages(int index) async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _blocks[index].imageFiles.clear();
      _blocks[index]
          .imageFiles
          .addAll(pickedImages.map((image) => File(image.path)));
    });
  }

  void _addNewBlock() {
    setState(() {
      _blocks.add(ImageDescriptionBlock());
      _controllers.add(TextEditingController());
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
                decoration: const BoxDecoration(
                  color: CorConstante.laranja,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.03, 0, 0),
                    child: Text(
                      'Registre fotos do seu serviço!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.075,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              ..._blocks.asMap().entries.map((entry) {
                int index = entry.key;
                ImageDescriptionBlock block = entry.value;

                return Column(
                  children: [
                    block.imageFiles.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: block.imageFiles.length,
                              itemBuilder: (context, imgIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FullScreenImageViewer(
                                          imageFiles: block.imageFiles,
                                          initialIndex: imgIndex,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child:
                                        Image.file(block.imageFiles[imgIndex]),
                                  ),
                                );
                              },
                            ),
                          ),
                    block.imageFiles.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                            child: InkWell(
                              onTap: () => _pickImages(index),
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
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.black),
                              ),
                            ),
                          )
                        : const Center(),
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
                            offset: Offset(0, 4),
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
                          controller: _controllers[index],
                          maxLines: null,
                          style: TextStyle(
                            color: CorConstante.cinzaEscuro,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Descrição:',
                            hintStyle: TextStyle(
                              color: CorConstante.cinza,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    _blocks.length > 1
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              MediaQuery.of(context).size.width * 0.05,
                              0,
                              0,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 0,
                                    offset: const Offset(-5, 5),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const Center(),
                    SizedBox(height: 20),
                    if (index == _blocks.length - 1)
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                              child: InkWell(
                                onTap: () => _addNewBlock(),
                                child: Container(
                                  width:
                                      45, // Defina a largura e altura para garantir que o container seja quadrado
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Fundo branco para o container
                                    shape: BoxShape.circle, // Forma circular
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // Deslocamento da sombra
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.add,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDescriptionBlock {
  List<File> imageFiles = [];
}
