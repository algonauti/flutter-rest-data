import 'package:flutter/material.dart';

class SizeConfig {
  // static double _blockWidth;
  // static double _blockHeight;

  static double textMultiplier;
  static double imageMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;

  void init(BoxConstraints constraints) {
    final _blockWidth = constraints.maxWidth / 100;
    final _blockHeight = constraints.maxHeight / 100;

    textMultiplier = _blockHeight;
    imageMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print('block width -> $_blockWidth, block height -> $_blockHeight');
  }
}
