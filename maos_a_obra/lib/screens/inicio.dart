import 'package:flutter/material.dart';
import 'package:maos_a_obra/components/cor_constante.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.125,
              decoration: const BoxDecoration(
                color: CorConstante.cinza,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  'Seja bem vindo!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                  MediaQuery.of(context).size.width * 0.05),
              child: Text(
                "O que você deseja?",
                style: TextStyle(
                  color: CorConstante.cinzaEscuro,
                  fontSize: MediaQuery.of(context).size.width * 0.065,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Material(
              elevation: 7,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CorConstante.laranja,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.045,
                            MediaQuery.of(context).size.width * 0.05,
                            0,
                            MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Text(
                            "Contratar\nServiços",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.065,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.045,
                            0,
                            0,
                            MediaQuery.of(context).size.width * 0.065,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.025,
                                0,
                                0,
                                0,
                              ),
                              child: Text(
                                "Login",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                  color: CorConstante.laranja,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        MediaQuery.of(context).size.width * 0.055,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/house2.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.055),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: Text(
                      "Mãos À Obra",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        color: CorConstante.laranja.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Material(
              elevation: 7,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CorConstante.azulClaro,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.045,
                            MediaQuery.of(context).size.width * 0.05,
                            0,
                            MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Text(
                            "Prestar\nServiços",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.065,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.045,
                            0,
                            0,
                            MediaQuery.of(context).size.width * 0.065,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.025,
                                0,
                                0,
                                0,
                              ),
                              child: Text(
                                "Login",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                  color: CorConstante.azulClaro,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        MediaQuery.of(context).size.width * 0.055,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/ferramenta.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.width * 0.075, 0, 0),
              child: Material(
                elevation: 7,
                borderRadius: BorderRadius.circular(20),
                color: CorConstante.laranja,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width * 0.0075,
                      0,
                      MediaQuery.of(context).size.width * 0.0075,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Mais sobre o aplicativo",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.055,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
