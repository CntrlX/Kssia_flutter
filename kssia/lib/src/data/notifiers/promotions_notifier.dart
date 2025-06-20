import 'dart:developer';
import 'package:kssia/src/data/models/promotions_model.dart';
import 'package:kssia/src/data/services/api_routes/promotions_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotions_notifier.g.dart';

@riverpod
class PromotionsNotifier extends _$PromotionsNotifier {
  List<Promotion> promotions = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 20;
  bool hasMore = true;
  bool isFirstLoad = true;
  @override
  List<Promotion> build() {
    return [];
  }

  Future<void> fetchMorePromotions() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    try {
      final newPromotions = await ref
          .read(fetchPromotionsProvider(pageNo: pageNo, limit: limit).future);
      promotions = [...promotions, ...newPromotions];
      pageNo++;
      hasMore = newPromotions.length == limit;
         isFirstLoad = false;
      state = promotions;
    } catch (e, stackTrace) {
      log(e.toString());

      log(stackTrace.toString());
    } finally {
      isLoading = false;
      log('im in people $promotions');
    }
  }
}