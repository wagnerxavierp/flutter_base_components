import 'package:flutter/material.dart';

import 'list_component_controller.dart';

abstract class CardWidget<T> extends StatelessWidget {
  final T model;
  final ListComponentController<T> controller;

  final double maxWidth;
  final double minWidth;

  const CardWidget({
    super.key,
    required this.model,
    required this.controller,
    this.maxWidth = 200,
    this.minWidth = 200,
  });

  @protected
  Widget buildCardContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildCardContent(context);
  }
}
