import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ListComponentController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxSet<T> selectedItems = <T>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasMore = true.obs;
  bool get isSelectionState => selectedItems.isNotEmpty;

  int _page = 1;
  int itemsPerPage = 50;

  List<dynamic>? filters;
  List<Map<String, dynamic>>? orderBys;

  TextEditingController textFieldController = TextEditingController();
  RxBool textFieldSearched = false.obs;
  Future<void> clearSearchField();
  Future<void> searchField(List<String> attributes);

  Future<Either<String, List<T>>> findPaginated({
    int page = 1,
    int limit = 50,
    List<dynamic>? filters,
    List<Map<String, dynamic>>? orderBys,
  });

  Future<void> handleItemTap(T item) async {}

  Future<void> deleteItem(T item) async {}

  Future<void> onDismissed(DismissDirection direction, T item) async {}

  void toggleSelection(T item) {
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
  }

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onClose() {
    textFieldController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    try {
      _page = 1;

      var resultFunction = await findPaginated(
        page: _page,
        limit: itemsPerPage,
        filters: filters,
        orderBys: orderBys,
      );

      resultFunction.fold(
        (error) => Get.snackbar('Erro', error),
        (newItems) {
          items.assignAll(newItems);
          hasMore.value = newItems.length == itemsPerPage;
        },
      );

      _page++;
    } finally {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => isLoading.value = false);
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;

    try {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => isLoading.value = true);

      var resultFunction = await findPaginated(
        page: _page,
        limit: itemsPerPage,
        filters: filters,
        orderBys: orderBys,
      );

      resultFunction.fold(
        (error) => Get.snackbar('Erro', error),
        (newItems) {
          if (newItems.length < itemsPerPage) hasMore.value = false;
          items.addAll(newItems);
          _page++;
        },
      );
    } finally {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => isLoading.value = false);
    }
  }

  //Função para identificar e atualizar o model dentro dos items
  void updateItem(T? item) {
    if (item == null) return;
    var indexModel = items.indexOf(item);
    items[indexModel] = item;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      items.refresh();
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }
  }
}
