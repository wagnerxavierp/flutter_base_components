import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../layout/wrap_responsive.dart';
import 'card_widget.dart';
import 'list_component_controller.dart';

enum ListComponentType {
  list,
  grid,
}

class ListComponent<T> extends StatefulWidget {
  final ListComponentController<T> controller;
  final CardWidget Function(BuildContext, T) itemBuilder;
  final ListComponentType type;

  const ListComponent({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.type = ListComponentType.list,
  });

  @override
  State<ListComponent<T>> createState() => _ListComponentState<T>();
}

class _ListComponentState<T> extends State<ListComponent<T>> {
  double maxWidthItem = 200;

  double minWidthItem = 200;

  CardWidget? cardItemWidget;

  RxBool isUpListing = false.obs;

  RxBool isDownListing = true.obs;

  @override
  Widget build(BuildContext context) {
    widget.controller.scrollController = ScrollController();

    widget.controller.scrollController.addListener(() {
      if (widget.controller.scrollController.position.pixels >=
          widget.controller.scrollController.position.maxScrollExtent) {
        isDownListing.value = false;
      } else {
        isDownListing.value = true;
      }

      if (widget.controller.scrollController.position.pixels <=
          widget.controller.scrollController.position.minScrollExtent) {
        isUpListing.value = false;
      } else {
        isUpListing.value = true;
      }
    });

    return Stack(
      children: [
        Obx(
          () {
            if (widget.controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (widget.controller.items.isEmpty &&
                !widget.controller.isLoading.value) {
              return InkWell(
                onTap: widget.controller.loadInitialData,
                child: const Center(
                  child: Icon(Icons.refresh_rounded),
                ),
              );
            }

            if (widget.controller.items.isNotEmpty) {
              cardItemWidget ??= widget.itemBuilder(
                context,
                widget.controller.items[0],
              );

              maxWidthItem = cardItemWidget?.maxWidth ?? maxWidthItem;
              minWidthItem = cardItemWidget?.minWidth ?? minWidthItem;
            }

            return RefreshIndicator(
              onRefresh: widget.controller.loadInitialData,
              child: widget.type == ListComponentType.list
                  ? ListView.builder(
                      controller: widget.controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget.controller.items.length +
                          _loadingIndicatorCount,
                      itemBuilder: (context, index) {
                        if (index >= widget.controller.items.length) {
                          return _buildLoadingIndicator();
                        }
                        return widget.itemBuilder(
                            context, widget.controller.items[index]);
                      },
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: WrapResponsive(
                            scrollController:
                                widget.controller.scrollController,
                            maxWidthItem: maxWidthItem,
                            minWidthItem: minWidthItem,
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: [
                              ...widget.controller.items.map(
                                (element) => Obx(
                                  () => widget.itemBuilder(
                                    context,
                                    widget.controller.items[widget
                                        .controller.items
                                        .indexOf(element)],
                                  ),
                                ),
                              ),
                              Container(
                                height: 64,
                                color: Colors.transparent,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(
                  () => isUpListing.value
                      ? InkWell(
                          onTap: () {
                            widget.controller.scrollController.animateTo(
                              widget.controller.scrollController.position
                                  .minScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () => isDownListing.value
                      ? InkWell(
                          onTap: () {
                            widget.controller.scrollController.animateTo(
                              widget.controller.scrollController.position
                                  .maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  int get _loadingIndicatorCount => widget.controller.hasMore.value ? 1 : 0;

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: widget.controller.hasMore.value
            ? const CircularProgressIndicator()
            : const Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }
}
