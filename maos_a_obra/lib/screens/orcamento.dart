import 'package:flutter/material.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:maos_a_obra/screens/imagem_completa.dart';

class Orcamento extends StatefulWidget {
  const Orcamento({super.key});

  @override
  State<Orcamento> createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  final List<File> _imageFiles = [];
  TextEditingController? controller;
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    setState(() {
      _imageFiles.clear();
      _imageFiles.addAll(pickedImages.map((image) => File(image.path)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Orçamento',
            style: TextStyle(color: CorConstante.azulClaro),
          ),
          centerTitle: true,
          leading: Container(
            width: MediaQuery.of(context).size.width * 0.08,
            height: MediaQuery.of(context).size.width * 0.08,
            decoration: BoxDecoration(
              border: Border.all(color: CorConstante.azulClaro, width: 3),
              color: Colors.transparent,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: CorConstante.azulClaro,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/fundo.png'), // Replace with your image path
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        MediaQuery.of(context).size.width * 0.05,
                        0,
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.1,
                        backgroundImage: const AssetImage(
                          'assets/images/profile.png',
                        ),
                      ),
                    ),
                    Text(
                      'NomeUsuário',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 10), // Add some spacing

                    Text(
                      '@usuario',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: Colors.white),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.width * 0.05,
                    0,
                    0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 0,
                          offset: const Offset(-5, 5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Add some spacing before the TextFormField
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.98,
                  decoration: BoxDecoration(
                    border: Border.all(color: CorConstante.azulClaro),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05),
                    child: TextField(
                      controller: controller,
                      maxLines: null,
                      style: TextStyle(
                        color: CorConstante.azulClaro,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Descreva o serviço necessário...',
                        hintStyle: TextStyle(
                          color: CorConstante
                              .azulClaro, // Blue color for hint text
                          fontSize: MediaQuery.of(context).size.width *
                              0.04, // Font size of the hint text
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                _imageFiles.isEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Faça o upload de algumas fotos de onde o serviço deverá ser realizado",
                          style: TextStyle(
                              color: CorConstante.laranja,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045),
                        ),
                      )
                    : const Center(),
                _imageFiles.isEmpty
                    ? Container()
                    : SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageFiles.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImageViewer(
                                      imageFiles: _imageFiles,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.file(_imageFiles[index]),
                              ),
                            );
                          },
                        ),
                      ),

                _imageFiles.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
                        child: ElevatedButton(
                          onPressed: _pickImages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black.withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.25,
                              MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                          child: const Icon(Icons.add_a_photo),
                        ),
                      )
                    : const Center(),
                _imageFiles.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.425,
                              height: MediaQuery.of(context).size.width * 0.125,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _imageFiles.clear();
                                  });
                                },
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                    color: CorConstante.laranja,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.425,
                              height: MediaQuery.of(context).size.width * 0.125,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    CorConstante.azulClaro,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Finalizar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(-5, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: CorConstante.laranja,
              selectedItemColor: CorConstante.laranja,
              unselectedItemColor: CorConstante.laranja,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Business',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'School',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
