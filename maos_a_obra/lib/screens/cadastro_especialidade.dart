import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/especialidade_descricao.dart';

class CadastroEspecialidadePage extends StatefulWidget {
  const CadastroEspecialidadePage({super.key});

  @override
  _CadastroEspecialidadePageState createState() =>
      _CadastroEspecialidadePageState();
}

class _CadastroEspecialidadePageState extends State<CadastroEspecialidadePage> {
  final String apiUrl = '${Link.link}/user/registro';
  final List<Map<String, dynamic>> professions = [
    {'icon': Icons.build, 'name': 'Pedreiro'},
    {'icon': Icons.format_paint, 'name': 'Pintor'},
    {'icon': Icons.electrical_services, 'name': 'Eletricista'},
    {'icon': Icons.plumbing, 'name': 'Encanador'},
    {'icon': Icons.cleaning_services, 'name': 'Faxineiro'},
    {'icon': Icons.carpenter, 'name': 'Carpinteiro'},
    {'icon': Icons.roofing, 'name': 'Telhadista'},
    {'icon': Icons.gavel, 'name': 'Serralheiro'},
    {'icon': Icons.build, 'name': 'Pedreiro'},
    {'icon': Icons.format_paint, 'name': 'Pintor'},
    {'icon': Icons.electrical_services, 'name': 'Eletricista'},
    {'icon': Icons.plumbing, 'name': 'Encanador'},
    {'icon': Icons.cleaning_services, 'name': 'Faxineiro'},
    {'icon': Icons.carpenter, 'name': 'Carpinteiro'},
    {'icon': Icons.roofing, 'name': 'Telhadista'},
    {'icon': Icons.gavel, 'name': 'Serralheiro'},
    {'icon': Icons.build, 'name': 'Pedreiro'},
    {'icon': Icons.format_paint, 'name': 'Pintor'},
    {'icon': Icons.electrical_services, 'name': 'Eletricista'},
    {'icon': Icons.plumbing, 'name': 'Encanador'},
    {'icon': Icons.cleaning_services, 'name': 'Faxineiro'},
    {'icon': Icons.carpenter, 'name': 'Carpinteiro'},
    {'icon': Icons.roofing, 'name': 'Telhadista'},
    {'icon': Icons.gavel, 'name': 'Serralheiro'},
  ];

  final Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                    'Quais são suas especialidades?',
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
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
                color:
                    Colors.white, // Ensure the container has a background color
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: GridView.builder(
                    itemCount: professions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(index)) {
                              selectedIndices.remove(index);
                            } else {
                              selectedIndices.add(index);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: selectedIndices.contains(index)
                                    ? Colors.blue
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: CorConstante.azulClaro, width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  professions[index]['icon'],
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              professions[index]['name'],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.325,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EspecialidadeDescricao()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CorConstante.azulClaro,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          'Continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
