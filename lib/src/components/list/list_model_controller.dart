import 'package:flutter_base_components/src/core/custom_message.dart';
import 'package:flutter_base_components/src/core/interface_repository.dart';
import 'package:flutter_base_components/src/models/abstract_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ListModelController<T extends AbstractModel>
    extends GetxController {
  late InterfaceRepository<T> repository;
  ListModelController(this.repository);

  RxList<T> itens = <T>[].obs;
  RxList<T> selecteds = <T>[].obs;

  ScrollController scrollItensController = ScrollController();
  int pageItens = 1;
  int limitItens = 20;

  RxBool isLoadingFetch = false.obs;
  RxBool isLoadingMore = false.obs;

  RxBool isSelectionState = false.obs;

  List<Map<String, dynamic>>? get filters => null;
  List<Map<String, dynamic>>? get orderBys => [
        {"field": "created_at", "descending": false}
      ];

  void resetData() {
    itens.clear();
    selecteds.clear();
    pageItens = 1;
    isLoadingFetch.value = false;
    isLoadingMore.value = false;
    isSelectionState.value = false;
  }

  Future<void> fetchItens() async {
    if (isLoadingFetch.value) {
      return;
    }
    isLoadingFetch.value = true;
    pageItens = 1;
    await repository
        .findPaginated(
      page: pageItens,
      limit: limitItens,
      filters: filters,
      orderBys: orderBys,
    )
        .then((value) {
      value.fold((l) {
        isLoadingFetch.value = false;
        itens.clear();
        errorMessageCustom(l);
      }, (r) {
        isLoadingFetch.value = false;
        itens.value = r;
        pageItens++;
      });
    });

    if (scrollItensController.hasClients) {
      scrollItensController.jumpTo(0);
    }
  }

  Future<void> moreItens() async {
    if (isLoadingMore.value) {
      return;
    }
    isLoadingMore.value = true;
    repository
        .findPaginated(
      page: pageItens,
      limit: limitItens,
      filters: filters,
      orderBys: orderBys,
    )
        .then((value) {
      value.fold((l) {
        isLoadingMore.value = false;
        itens.clear();
        errorMessageCustom(l);
      }, (r) {
        isLoadingMore.value = false;
        if (r.isNotEmpty) {
          itens.addAll(r);
          pageItens++;
        }
      });
    });
  }

  void onTap(BuildContext context, T model);

  void onTapEdit(BuildContext context, T model);

  void onTapSelect(BuildContext context, T model) {
    if (selecteds.contains(model)) {
      selecteds.remove(model);
    } else {
      selecteds.add(model);
    }
    // totalSelecteds.value = selecteds.length;
    if (selecteds.isNotEmpty && !isSelectionState.value) {
      isSelectionState.value = true;
    } else if (selecteds.isEmpty && isSelectionState.value) {
      isSelectionState.value = false;
    }
  }

  void onTapRemove(BuildContext context, T model) async {
    var result = await repository.delete(model);
    result.fold((l) {
      errorMessageCustom(l);
    }, (r) {
      selecteds.remove(model);
      itens.remove(model);
      update();
    });
  }

  void onTapSelectAll(bool? value) {
    if (value == null) {
      return;
    }
    if (value) {
      selecteds.clear();
      selecteds.addAll(itens);
    } else {
      selecteds.clear();
    }
    // totalSelecteds.value = selecteds.length;
    isSelectionState.value = selecteds.isNotEmpty;
  }

  void onTapRemoveSelecteds() async {
    var result = await repository.deleteAll(selecteds);
    result.fold((l) {
      errorMessageCustom(l);
    }, (r) {
      selecteds.clear();
      isSelectionState.value = selecteds.isNotEmpty;
      fetchItens();
    });
  }
}
