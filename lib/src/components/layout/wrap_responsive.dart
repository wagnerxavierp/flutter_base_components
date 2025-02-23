import 'package:flutter/material.dart';

class WrapResponsive extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;
  final double? maxWidthWrap;
  final double? maxHeightWrap;
  final double maxWidthItem;
  final double minWidthItem;
  final double? maxHeightItem;
  final double paddingItem;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;

  const WrapResponsive({
    super.key,
    this.scrollController,
    required this.children,
    this.maxWidthWrap,
    this.maxHeightWrap,
    this.maxWidthItem = 500,
    this.minWidthItem = 250,
    this.maxHeightItem,
    this.paddingItem = 8,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  });

  double widthItem(BoxConstraints constraints) {
    final spacingPerItem = minWidthItem + (paddingItem * 2);
    final itemsPerRow = (constraints.maxWidth / spacingPerItem).floor();
    double widthItem = constraints.maxWidth / itemsPerRow - (paddingItem * 2);

    return widthItem.clamp(minWidthItem, maxWidthItem);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double computedWidthItem = widthItem(constraints);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Wrap(
            direction: direction,
            alignment: alignment,
            spacing: spacing,
            runAlignment: runAlignment,
            runSpacing: runSpacing,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            clipBehavior: clipBehavior,
            children: children.map((child) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: computedWidthItem,
                  maxHeight: maxHeightItem ?? double.infinity,
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
}
