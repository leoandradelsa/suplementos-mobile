import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:suplementos/autenticador.dart';
import 'package:suplementos/components/suplemento_card.dart';
import 'package:suplementos/estado.dart';
import 'package:suplementos/services/auth_service.dart';

class Suplementos extends StatefulWidget {
  const Suplementos({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SuplementosState();
  }
}

const int tamanhoPagina = 4;

class _SuplementosState extends State<Suplementos> {
  late dynamic _feedEstatico;
  List<dynamic> _suplementos = [];
  int _proximaPagina = 1;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _lerFeedEstatico();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _lerFeedEstatico() async {
    final String conteudoJson =
        await rootBundle.loadString("lib/resources/json/feed.json");
    _feedEstatico = await json.decode(conteudoJson);

    _carregarSuplementos();
  }

  void _carregarSuplementos() {
    setState(() {
      _carregando = true;
    });

    var maisSuplementos = [];
    maisSuplementos = _suplementos;

    final totalSuplementosParaCarregar = _proximaPagina * tamanhoPagina;
    if (_feedEstatico["suplementos"].length >= totalSuplementosParaCarregar) {
      maisSuplementos =
          _feedEstatico["suplementos"].sublist(0, totalSuplementosParaCarregar);
    }

    setState(() {
      _suplementos = maisSuplementos;
      _proximaPagina = _proximaPagina + 1;

      _carregando = false;
    });
  }

  Future<void> _atualizarSuplementos() async {
    _suplementos = [];
    _proximaPagina = 1;

    _carregarSuplementos();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<EstadoApp>();

    bool usuarioLogado = estadoApp.usuario != null;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text("Suplementos"),
          actions: [
            usuarioLogado
                ? IconButton(
                    onPressed: () {
                      signUserOut;
                      setState(() {
                        estadoApp.onLogout();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Você não está mais conectado")),
                      );
                    },
                    icon: const Icon(Icons.logout))
                : IconButton(
                    onPressed: () {
                      AuthService().signInWithGoogle();

                      String nome =
                          FirebaseAuth.instance.currentUser!.displayName!;
                      String email = FirebaseAuth.instance.currentUser!.email!;

                      Usuario usuario = Usuario(nome, email);

                      setState(() {
                        estadoApp.onLogin(usuario);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Você foi conectado como $nome")),
                      );
                    },
                    icon: const Icon(Icons.login))
          ],
        ),
        body: FlatList(
            data: _suplementos,
            numColumns: 2,
            loading: _carregando,
            onRefresh: () {
              return _atualizarSuplementos();
            },
            onEndReached: () => _carregarSuplementos(),
            buildItem: (item, int indice) {
              return SizedBox(
                  height: 400, child: SuplementoCard(suplemento: item));
            }));
  }
}
