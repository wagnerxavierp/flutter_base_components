import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ListComponentController<T> extends GetxController {
  final RxList<T> items = <T>[].obs;
  final RxSet<T> selectedItems = <T>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  bool get isSelectionState => selectedItems.isNotEmpty;

  ScrollController scrollController = ScrollController();
  int _page = 1;
  int itemsPerPage = 50;

  // =====================================================
  List<dynamic>? get filters => null;
  List<Map<String, dynamic>>? get orderBys => null;
  Future<Either<String, List<T>>> findPaginated({
    int page = 1,
    int limit = 50,
    List<dynamic>? filters,
    List<Map<String, dynamic>>? orderBys,
  });
  void handleItemTap(T item);
  Future<void> deleteItem(T item);
  // =====================================================

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
    loadInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
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
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;

    try {
      isLoading.value = true;

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
      isLoading.value = false;
    }
  }

  // Buscar mais items quando o scroll chegar ao final
  void _handleScroll() {
    if (_shouldLoadMore()) loadMore();
  }

  // Verificar se o scroll chegou ao final
  bool _shouldLoadMore() {
    return !isLoading.value &&
        hasMore.value &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200;
  }

  //Função para selecionar um item
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

  //Função para identificar e atualizar o model dentro dos items
  void updateItem(T? item) {
    if (item == null) return;
    var indexModel = items.indexOf(item);
    items[indexModel] = item;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      items.refresh();
    });
  }
}
