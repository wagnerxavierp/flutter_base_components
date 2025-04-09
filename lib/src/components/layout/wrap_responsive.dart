import 'package:flutter/material.dart';
import 'package:flutter_base_components/components.dart';
import 'package:reorderables/reorderables.dart';

class WrapResponsive extends StatelessWidget {
  final ScrollController? scrollController;
  final List<CardWidget> children;
  final double paddingItem;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final bool reorderable;
  final void Function(int, int)? onReorder;

  const WrapResponsive({
    super.key,
    this.scrollController,
    required this.children,
    this.paddingItem = 8,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.reorderable = false,
    this.onReorder,
  });

  double widthItem(
      BoxConstraints constraints, double minWidthItem, double maxWidthItem) {
    final spacingPerItem = minWidthItem + (paddingItem * 2);
    final itemsPerRow = (constraints.maxWidth / spacingPerItem).floor();
    double widthItem = constraints.maxWidth / itemsPerRow - (paddingItem * 2);

    return widthItem.clamp(minWidthItem, maxWidthItem);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: ReorderableWrap(
            onReorder: onReorder ?? _onReorder,
            enableReorder: reorderable,
            direction: direction,
            alignment: alignment,
            spacing: spacing,
            runAlignment: runAlignment,
            runSpacing: runSpacing,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            children: children.map((child) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth:
                      widthItem(constraints, child.minWidth, child.maxWidth),
                ),
                margin: EdgeInsets.all(paddingItem),
                child: child,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
  }
}
