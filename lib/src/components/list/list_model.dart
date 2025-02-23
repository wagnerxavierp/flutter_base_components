// import 'package:flutter_base_components/src/components/layout/wrap_responsive.dart';
import 'package:flutter_base_components/src/models/abstract_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/custom_message.dart';
import 'list_model_controller.dart';
import 'dart:io' show Platform;

class ListModel<C extends ListModelController, W extends BaseItemkWidget,
    T extends AbstractModel> extends GetView<C> {
  final C controllerGetX;
  final double maxWidthItem;
  final double minWidthItem;
  final bool enableSelectionAll;
  final bool enableExcludeSelecteds;
  final ScrollController? scrollItensController;
  final EdgeInsetsGeometry? marginItens;

  final W Function(
    int index,
  ) itemBuilder;

  const ListModel({
    super.key,
    required this.controllerGetX,
    required this.itemBuilder,
    this.maxWidthItem = 500,
    this.minWidthItem = 300,
    this.enableSelectionAll = true,
    this.enableExcludeSelecteds = true,
    this.scrollItensController,
    this.marginItens,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controllerGetX,
      initState: (_) {
        if (scrollItensController != null) {
          controllerGetX.scrollItensController = scrollItensController!;
        }
        controllerGetX.resetData();
        controllerGetX.fetchItens();
        controllerGetX.scrollItensController.addListener(() {
          if (controllerGetX.scrollItensController.position.pixels ==
              controllerGetX.scrollItensController.position.maxScrollExtent) {
            controllerGetX.moreItens();
          }
        });
        controllerGetX.isSelectionState.value = false;
        controllerGetX.selecteds.clear();
      },
      builder: (getController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        if (enableSelectionAll)
                          Obx(
                            () => getController.itens.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        getController.onTapSelectAll(
                                            !(getController.selecteds.length ==
                                                getController.itens.length));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: getController
                                                    .selecteds.length ==
                                                getController.itens.length,
                                            onChanged: (value) {
                                              getController
                                                  .onTapSelectAll(value);
                                            },
                                          ),
                                          if (getController
                                              .isSelectionState.value)
                                            Text(
                                              'Selecionados: ${getController.selecteds.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          if (!getController
                                              .isSelectionState.value)
                                            Text(
                                              'Selecionar todos',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        if (enableExcludeSelecteds)
                          Obx(
                            () => getController.isSelectionState.value
                                ? InkWell(
                                    onTap: () {
                                      confirmationDialogOperation(
                                        context: context,
                                        title: 'Excluir',
                                        message:
                                            'Deseja realmente excluir os itens selecionados?',
                                        onConfirm: () {
                                          getController.onTapRemoveSelecteds();
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Excluir selecionados',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Obx(
                    () {
                      if (getController.isLoadingFetch.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (getController.itens.isEmpty) {
                        return const Center(
                          child: Icon(Icons.post_add,
                              size: 100, color: Colors.grey),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  Obx(
                    () => ListView.builder(
                        controller: getController.scrollItensController,
                        itemCount: getController.itens.length + 2,
                        itemBuilder: (context, index) {
                          if (index == getController.itens.length ||
                              index == (getController.itens.length + 1)) {
                            if (Platform.isAndroid) {
                              return const SizedBox(height: 64);
                            }
                            return const SizedBox.shrink();
                          }
                          return Container(
                            margin: marginItens ?? const EdgeInsets.all(4.0),
                            child: itemBuilder(index),
                          );
                        }),
                  ),
                  // Obx(
                  //   () => WrapResponsive(
                  //     scrollController: getController.scrollItensController,
                  //     maxWidthItem: maxWidthItem,
                  //     minWidthItem: minWidthItem,
                  //     direction: Axis.horizontal,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: [
                  //       ...getController.itens.map(
                  //         (element) => Obx(
                  //           () => itemBuilder(
                  //             getController.itens.indexOf(element),
                  //           ),
                  //         ),
                  //       ),
                  //       if (Platform.isAndroid)
                  //         Container(
                  //           height: 64,
                  //           color: Colors.transparent,
                  //         )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Obx(
              () => getController.isLoadingMore.value
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 500, maxHeight: 10),
                        child: const LinearProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class BaseItemkWidget<T extends AbstractModel> extends StatelessWidget {
  final int index;
  final bool enumarate;

  final ListModelController<T> controller;

  final Function(BuildContext, T)? onTap;
  final Function(BuildContext, T)? onLongPress;
  final Function(BuildContext, T)? onTapRemove;
  final Function(BuildContext, T)? onTapEdit;
  final Function(BuildContext, T)? onTapSelect;

  const BaseItemkWidget({
    super.key,
    required this.index,
    this.onTap,
    this.onLongPress,
    this.onTapRemove,
    this.onTapEdit,
    this.onTapSelect,
    this.enumarate = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ModelItemCard<T extends AbstractModel> extends BaseItemkWidget<T> {
  const ModelItemCard({
    super.key,
    required super.index,
    super.onTap,
    super.onLongPress,
    super.onTapRemove,
    super.onTapEdit,
    super.onTapSelect,
    super.enumarate = true,
    required super.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: controller.selecteds.contains(controller.itens[index])
            ? Colors.blue[100]
            : Theme.of(context).cardColor,
        child: Stack(
          children: [
            InkWell(
              radius: 8.0,
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if (controller.isSelectionState.value) {
                  controller.onTapSelect(context, controller.itens[index]);
                } else {
                  if (onTap != null) {
                    onTap?.call(context, controller.itens[index]);
                  } else {
                    controller.onTap(context, controller.itens[index]);
                  }
                }
                // if (controller.selecteds.isNotEmpty &&
                //     !controller.isSelectionState.value) {
                //   controller.isSelectionState.value = true;
                // } else if (controller.selecteds.isEmpty &&
                //     controller.isSelectionState.value) {
                //   controller.isSelectionState.value = false;
                // }
              },
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress?.call(context, controller.itens[index]);
                } else {
                  controller.onTapSelect(context, controller.itens[index]);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (enumarate)
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${controller.itens[index].id ?? ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 32.0),
                                  child: Text(
                                    controller
                                        .itens[index].listTilesValues.first,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 70.0),
                                  child: Text(
                                    controller.itens[index].listTilesValues
                                                .length >
                                            1
                                        ? controller
                                            .itens[index].listTilesValues[1]
                                        : "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!controller.isSelectionState.value)
              Positioned(
                right: 0,
                top: 0,
                child: PopupMenuButton(
                  tooltip: 'Opções',
                  iconSize: 15,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        if (onTapSelect != null) {
                          onTapSelect?.call(context, controller.itens[index]);
                        } else {
                          controller.onTapSelect(
                              context, controller.itens[index]);
                        }
                      },
                      child: Text(
                        'Selecionar',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        confirmationDialogOperation(
                          context: context,
                          title: 'Excluir',
                          message: 'Deseja realmente excluir?',
                          onConfirm: () {
                            if (onTapRemove != null) {
                              onTapRemove?.call(
                                  context, controller.itens[index]);
                            } else {
                              controller.onTapRemove(
                                  context, controller.itens[index]);
                            }
                          },
                        );
                      },
                      child: Text(
                        'Excluir',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        if (onTapEdit != null) {
                          onTapEdit?.call(context, controller.itens[index]);
                        } else {
                          controller.onTapEdit(
                              context, controller.itens[index]);
                        }
                      },
                      child: Text(
                        'Editar',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              right: 0,
              top: 0,
              child: Obx(
                () => controller.isSelectionState.value
                    ? Checkbox(
                        value: controller.selecteds
                            .contains(controller.itens[index]),
                        onChanged: (value) {
                          if (onTapSelect != null) {
                            onTapSelect?.call(context, controller.itens[index]);
                          } else {
                            controller.onTapSelect(
                                context, controller.itens[index]);
                          }
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
