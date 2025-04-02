import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kssia/src/data/models/events_model.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/services/api_routes/events_api.dart';
import 'package:kssia/src/data/services/api_routes/requirement_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'requirements_notifier.g.dart';

@riverpod
class RequirementsNotifier extends _$RequirementsNotifier {
  List<Requirement> requirements = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 2;
  bool hasMore = true;

  @override
  List<Requirement> build() {
    return [];
  }

  Future<void> fetchMoreRequirements() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    Future(() {
      state = [...requirements];
    });

    try {
      final newRequirements = await ref
          .read(fetchRequirementsProvider(pageNo: pageNo, limit: limit).future);

      requirements = [...requirements, ...newRequirements];
      pageNo++;
      hasMore = newRequirements.length == limit;

      Future(() {
        state = [...requirements];
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;
      Future(() {
        state = [...requirements];
      });
      log('im in people $requirements');
    }
  }

  Future<void> refreshRequirements() async {
    requirements = [];
    pageNo = 1;
    hasMore = true;
    await fetchMoreRequirements();
  }

  /// Function to remove all requirements by a specific author ID.
  void removeRequirementsByAuthor(String authorId) {
    requirements = requirements
        .where((requirement) => requirement.author?.id != authorId)
        .toList();

    // Update state after filtering
    state = [...requirements];
    log('Removed requirements by author: $authorId');
  }
}

  //  Future<void> refresh({required String blockedUserId}) async {
  //   if (isLoading) return;

  //   isLoading = true;

  //   try {
  //     // Fetch requirements for the current page and limit
  //     final refreshedRequirements = requirements.where((requirement) => requirement.author?.id!=blockedUserId).toList();

  //     requirements = refreshedRequirements;

  //     state = requirements;

  //   } catch (e, stackTrace) {
  //     log(e.toString());
  //     log(stackTrace.toString());
  //   } finally {
  //     isLoading = false;
  //     log('Requirements refreshed: $requirements');
  //   }
  // }

  // Function to refresh the requirements while keeping the current page and limit
  // Future<void> refreshRequirements() async {
  //   if (isLoading) return;

  //   isLoading = true;

  //   try {
  //     pageNo = 1;
  //     final refreshedRequirements = await ref
  //         .read(fetchRequirementsProvider(pageNo: pageNo, limit: limit).future);
  //     requirements = refreshedRequirements;
  //     hasMore = refreshedRequirements.length == limit;
  //     state = requirements; // Update the state with the refreshed feed\
  //     log('refreshed');
  //   } catch (e, stackTrace) {
  //     log(e.toString());
  //     log(stackTrace.toString());
  //   } finally {
  //     isLoading = false;
  //   }
  // }
// }
