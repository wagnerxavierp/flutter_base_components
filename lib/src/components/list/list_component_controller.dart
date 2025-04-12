// ignore_for_file: avoid_print

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_components/components.dart';
import 'package:flutter_base_components/src/components/list/list_order_by.dart';
import 'package:get/get.dart';

abstract class ListComponentController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxSet<T> selectedItems = <T>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasMore = true.obs;
  bool get isSelectionState => selectedItems.isNotEmpty;

  int _page = 1;
  int itemsPerPage = 50;

  List<ListFilter>? filters;
  List<ListOrderBy>? orderBys;

  // Search input field ----------------------------------
  TextEditingController textFieldController = TextEditingController();
  RxBool textFieldSearched = false.obs;

  Future<void> clearSearchField({
    List<ListFilter>? filters,
    List<ListOrderBy>? orderBys,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      textFieldSearched.value = false;
      isLoading.value = true;
      textFieldController.clear();
      this.filters = filters;
      this.orderBys = orderBys;
      loadInitialData();
    });
  }

  Future<void> searchField({
    List<ListFilter>? filters,
    List<ListOrderBy>? orderBys,
  }) async {
    if (textFieldController.text.isEmpty) {
      clearSearchField(
        filters: filters,
        orderBys: orderBys,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = true;
      });
      this.filters = filters;
      this.orderBys = orderBys;
      await loadInitialData();
    }
  }
  //-------------------------------------------------------

  Future<Either<String, List<T>>> findItems({
    int page = 1,
    int limit = 50,
    List<ListFilter>? filters,
    List<ListOrderBy>? orderBys,
  });

  Future<void> handleItemTap(T item) async {}

  Future<void> deleteItem(T item) async {}

  Future<void> onDismissed(DismissDirection direction, T item) async {}

  void toggleSelection(T item) {
    try {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectedItems.refresh();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        items.refresh();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    textFieldController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    try {
      _page = 1;

      var resultFunction = await findItems(
        page: _page,
        limit: itemsPerPage,
        filters: filters,
        orderBys: orderBys,
      );

      resultFunction.fold(
        (error) => Get.snackbar('Erro', error),
        (newItems) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            items.assignAll(newItems);
          });
          if (newItems.length < itemsPerPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              hasMore.value = false;
            });
          }
        },
      );

      _page++;
    } catch (e) {
      print(e);
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;
      });
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;

    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = true;
      });

      var resultFunction = await findItems(
        page: _page,
        limit: itemsPerPage,
        filters: filters,
        orderBys: orderBys,
      );

      resultFunction.fold(
        (error) => Get.snackbar('Erro', error),
        (newItems) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            items.addAll(newItems);
          });
          if (newItems.length < itemsPerPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              hasMore.value = false;
            });
          }
          _page++;
        },
      );
    } catch (e) {
      print(e);
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = false;
      });
    }
  }

  void updateItem(T? item) {
    try {
      if (item == null) return;
      var indexModel = items.indexOf(item);
      items[indexModel] = item;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        items.refresh();
      });
    } catch (e) {
      print(e);
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
  }
}
