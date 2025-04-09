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
  final ListComponentController<T> listComponentController;
  final CardWidget Function(BuildContext, T) itemBuilder;
  final ListComponentType type;
  final ScrollController? scrollController;
  final bool reorderable;

  const ListComponent({
    super.key,
    required this.listComponentController,
    required this.itemBuilder,
    this.type = ListComponentType.list,
    this.scrollController,
    this.reorderable = false,
  });

  @override
  State<ListComponent<T>> createState() => _ListComponentState<T>();
}

class _ListComponentState<T> extends State<ListComponent<T>> {
  late ScrollController scrollController;
  RxBool isUpListing = false.obs;
  RxBool isDownListing = true.obs;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();

    scrollController.addListener(
      () {
        if (_isDownScroll()) {
          isDownListing.value = false;
        } else {
          isDownListing.value = true;
        }

        if (_isUpScroll()) {
          isUpListing.value = false;
        } else {
          isUpListing.value = true;
        }

        if (_shouldLoadMore()) widget.listComponentController.loadMore();
      },
    );
  }

  bool _isDownScroll() =>
      scrollController.position.pixels >=
      scrollController.position.maxScrollExtent;

  bool _isUpScroll() =>
      scrollController.position.pixels <=
      scrollController.position.minScrollExtent;

  // Verificar se o scroll chegou ao final
  bool _shouldLoadMore() {
    return !widget.listComponentController.isLoading.value &&
        widget.listComponentController.hasMore.value &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder(
          init: widget.listComponentController,
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: controller.loadInitialData,
              child: widget.type == ListComponentType.list
                  ? widget.reorderable
                      ? Obx(
                          () => ReorderableListView.builder(
                            onReorder: controller.onReorder,
                            scrollController: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.items.length,
                            itemBuilder: (context, index) {
                              return widget.itemBuilder(
                                  context, controller.items[index]);
                            },
                          ),
                        )
                      : Obx(
                          () => ListView.builder(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.items.length,
                            itemBuilder: (context, index) {
                              return widget.itemBuilder(
                                  context, controller.items[index]);
                            },
                          ),
                        )
                  : Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => WrapResponsive(
                              scrollController: scrollController,
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              onReorder: controller.onReorder,
                              reorderable: widget.reorderable,
                              children: controller.items
                                  .map(
                                    (element) => widget.itemBuilder(
                                      context,
                                      controller.items[
                                          controller.items.indexOf(element)],
                                    ),
                                  )
                                  .toList(),
                            ),
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
                            scrollController.animateTo(
                              scrollController.position.minScrollExtent,
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
                                  color: Colors.grey.withValues(alpha: 0.5),
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
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
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
                                  color: Colors.grey.withValues(alpha: 0.5),
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
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Obx(
            () => widget.listComponentController.isLoading.value
                ? const SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
