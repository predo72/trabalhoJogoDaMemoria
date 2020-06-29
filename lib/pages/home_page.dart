import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jogo_da_memoria/models/carta.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _vitorias = 0;

  List<Carta> cartas = [
    Carta(id: 1, grupo: 1, cor: Colors.amber, icone: Icons.ac_unit),
    Carta(id: 2, grupo: 1, cor: Colors.amber, icone: Icons.ac_unit),
    Carta(id: 3, grupo: 2, cor: Colors.blue, icone: Icons.access_alarm),
    Carta(id: 4, grupo: 2, cor: Colors.blue, icone: Icons.access_alarm),
    Carta(id: 5, grupo: 3, cor: Colors.orange, icone: Icons.account_circle),
    Carta(id: 6, grupo: 3, cor: Colors.orange, icone: Icons.account_circle),
    Carta(id: 7, grupo: 4, cor: Colors.brown, icone: Icons.adb),
    Carta(id: 8, grupo: 4, cor: Colors.brown, icone: Icons.adb),
    Carta(id: 9, grupo: 5, cor: Colors.teal, icone: Icons.add_shopping_cart),
    Carta(id: 10, grupo: 5, cor: Colors.teal, icone: Icons.add_shopping_cart),
    Carta(id: 11, grupo: 6, cor: Colors.cyan, icone: Icons.airplanemode_active),
    Carta(id: 12, grupo: 6, cor: Colors.cyan, icone: Icons.airplanemode_active),
    Carta(id: 13, grupo: 7, cor: Colors.pink, icone: Icons.assistant_photo),
    Carta(id: 14, grupo: 7, cor: Colors.pink, icone: Icons.assistant_photo),
    Carta(id: 15, grupo: 8, cor: Colors.green, icone: Icons.bookmark_border),
    Carta(id: 16, grupo: 8, cor: Colors.green, icone: Icons.bookmark_border)
  ];

  Map<int, List<Carta>> cartasAgrupadasPorGrupo = Map<int, List<Carta>>();
  bool aguardandoCartasErradas = false;

  @override
  void initState() {
    cartas.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: Text(
            'Pontos: ${cartasAgrupadasPorGrupo.length} Vitorias: $_vitorias'),
      ),
      body: _criaTabuleiroCartas(),
    );
  }

  Widget _criaTabuleiroCartas() {
    return GridView.count(
      padding: EdgeInsets.all(5.0),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _criaListaCartas(),
    );
  }

  List<Widget> _criaListaCartas() {
    return cartas.map((Carta carta) => _criaCarta(carta)).toList();
  }

  Widget _criaCarta(Carta carta) {
    return GestureDetector(
      onTap: !aguardandoCartasErradas && !carta.visivel
          ? () => _mostraCarta(carta)
          : null,
      child: Card(
        child: AnimatedContainer(
          color: carta.visivel ? carta.cor : Colors.grey,
          duration: Duration(milliseconds: 400),
          child: _criaConteudoCarta(carta),
        ),
      ),
    );
  }

  Widget _criaConteudoCarta(Carta carta) {
    if (carta.visivel) {
      return Icon(
        carta.icone,
      );
    } else {
      return Container();
    }
  }

  _mostraCarta(Carta carta) {
    setState(() {
      carta.visivel = !carta.visivel;
    });
    _verificaAcerto();
  }

  void _verificaAcerto() {
    List<Carta> cartasVisiveis = _getCartasVisiveis();
    if (cartasVisiveis.length >= 2) {
      cartasAgrupadasPorGrupo = _getCartasAgrupadas(cartasVisiveis);
      List<Carta> cartasIncorretas =
          _getCartasIcorretas(cartasAgrupadasPorGrupo);
      if (cartasIncorretas.length >= 2) {
        _escondeCartas(cartasIncorretas);
      } else {
        _verificaVitoria();
      }
    }
  }

  void _escondeCartas(List<Carta> value) {
    setState(() {
      aguardandoCartasErradas = true;
    });
    Timer(Duration(seconds: 1), () {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          value[i].visivel = false;
        });
      }
      setState(() {
        aguardandoCartasErradas = false;
      });
    });
  }

  List<Carta> _getCartasVisiveis() {
    return cartas.where((carta) => carta.visivel).toList();
  }

  Map<int, List<Carta>> _getCartasAgrupadas(List<Carta> cartas) {
    return groupBy(cartas, (Carta carta) => carta.grupo);
  }

  List<Carta> _getCartasIcorretas(
      // Cria o map para fazer o forEach
      Map<int, List<Carta>> cartasAgrupadasPorGrupo) {
    List<Carta> cartasIncorretas = [];
    cartasAgrupadasPorGrupo.forEach((key, value) {
      if (value.length < 2) {
        cartasIncorretas.add(value[0]);
      }
    });
    return cartasIncorretas;
  }

  void _verificaVitoria() {
    if (_getCartasVisiveis().length == 16) {
      setState(() {
        _vitorias++;
      });
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vitória!!!"),
          content: Text("Deseja continar ou iniciar um novo jogo?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Continuar"),
              onPressed: () {
                _escondeCartas(cartas);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Iniciar novo"),
              onPressed: () {
                setState(() {
                  _vitorias = 0;
                });
                _escondeCartas(cartas);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
