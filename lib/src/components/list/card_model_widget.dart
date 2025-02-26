import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'card_widget.dart';

class CardModel<T> extends CardWidget<T> {
  const CardModel({super.key, required super.model, required super.controller})
      : super(maxWidth: 400, minWidth: 300);

  @override
  Widget buildCardContent(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedItems.contains(model);

      return Dismissible(
        key: Key(model.hashCode.toString()),
        direction: DismissDirection.endToStart,
        background: _buildDismissibleBackground(),
        onDismissed: (_) => controller.deleteItem(model),
        child: InkWell(
          onTap: controller.isSelectionState
              ? () => controller.toggleSelection(model)
              : () => controller.handleItemTap(model),
          onLongPress: () => controller.toggleSelection(model),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.1) : null,
              border: Border.all(
                color: isSelected
                    ? Colors.blue.withOpacity(0.7)
                    : Colors.transparent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.check_circle, color: Colors.blue),
                  ),
                if (controller.isSelectionState && !isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.circle_outlined, color: Colors.grey),
                  ),
                Expanded(child: buildCardContent(context)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
