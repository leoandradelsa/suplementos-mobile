import 'package:flutter/material.dart';
import 'package:suplementos/estado.dart';
import 'package:suplementos/pages/detalhes.dart';

class SuplementoCard extends StatelessWidget {
  final dynamic suplemento;

  const SuplementoCard({super.key, required this.suplemento});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(suplemento["_id"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Detalhes()),
        );
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Image.asset(
            "lib/resources/img/${suplemento["product"]["blobs"][0]["file"]}",
            height: 100,
            fit: BoxFit.cover,
          ),
          Row(children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                    "lib/resources/img/${suplemento["company"]["avatar"]}")),
            Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(suplemento["company"]["name"],
                    style: const TextStyle(fontSize: 15))),
          ]),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Text(suplemento["product"]["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16))),
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
              child: Text(suplemento["product"]["description"])),
          const Spacer(),
          Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child:
                    Text("R\$ ${suplemento['product']['price'].toString()}")),
            Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 5),
                child: Row(children: [
                  const Icon(Icons.favorite_rounded,
                      color: Colors.red, size: 18),
                  Text(suplemento["likes"].toString())
                ])),
          ])
        ]),
      ),
    );
  }
}
