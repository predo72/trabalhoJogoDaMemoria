import 'package:flutter/material.dart';

class Carta {
  int id;
  int grupo;
  bool visivel;
  Color cor;
  IconData icone;

  Carta({this.id, this.grupo, this.visivel = false, this.cor, this.icone});
}
