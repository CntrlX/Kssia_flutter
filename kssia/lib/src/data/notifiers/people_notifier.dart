import 'dart:developer';

import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'people_notifier.g.dart';

@riverpod
class PeopleNotifier extends _$PeopleNotifier {
  List<UserModel> users = [];
  bool isLoading = false;
  int pageNo = 1;
  final int limit = 9;
  bool hasMore = true;

  @override
  List<UserModel> build() {
    return [];
  }

  Future<void> fetchMoreUsers() async {
    if (isLoading || !hasMore) return;

    isLoading = true;

    // Delay state update to avoid modifying during widget build
    Future(() {
      state = [...users];
    });

    try {
      final newUsers = await ref
          .read(fetchUsersProvider(pageNo: pageNo, limit: limit).future);

      users = [...users, ...newUsers];
      pageNo++;
      hasMore = newUsers.length == limit;

      // Delay state update to trigger rebuild after data is fetched
      Future(() {
        state = [...users];
      });
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      isLoading = false;

      // Ensure state update after fetch completion
      Future(() {
        state = [...users];
      });

      log('Fetched users: $users');
    }
  }
}
