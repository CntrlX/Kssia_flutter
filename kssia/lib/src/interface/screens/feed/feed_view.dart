import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/notifiers/requirements_notifier.dart';
import 'package:kssia/src/data/services/api_routes/requirement_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/Shimmer/requirement.dart';
import 'package:kssia/src/interface/common/block_report.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/common/upgrade_dialog.dart';
import 'package:shimmer/shimmer.dart';

class FeedView extends ConsumerStatefulWidget {
  FeedView({super.key});

  @override
  ConsumerState<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends ConsumerState<FeedView> {
  final TextEditingController requirementContentController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialFeeds();
  }

  Future<void> _fetchInitialFeeds() async {
    await ref
        .read(requirementsNotifierProvider.notifier)
        .fetchMoreRequirements();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      log('Reached the bottom of the list');
      ref.read(requirementsNotifierProvider.notifier).fetchMoreRequirements();
    }
  }

  File? _requirementImage;
  ApiRoutes api = ApiRoutes();

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      setState(() {
        _requirementImage = File(result.files.single.path!);
      });
      return _requirementImage;
    }
    return null;
  }

  void _openModalSheet({required String sheet}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ShowAddRequirementSheet(
            pickImage: _pickFile,
            context1: context,
            textController: requirementContentController,
            imageType: 'requirement',
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final requirements = ref.watch(requirementsNotifierProvider);
        final isLoading =
            ref.read(requirementsNotifierProvider.notifier).isLoading;

        return RefreshIndicator(
          onRefresh: () => ref
              .read(requirementsNotifierProvider.notifier)
              .refreshRequirements(),
          child: Scaffold(
            body: Stack(
              children: [
                ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    if (requirements.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: requirements.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == requirements.length && isLoading) {
                            // Show loading spinner when fetching more requirements
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingAnimation(),
                              ),
                            );
                          }

                          final requirement = requirements[index];
                          if (requirement.status == 'approved') {
                            return _buildPost(
                              withImage: requirement.image != null &&
                                  requirement.image!.isNotEmpty,
                              requirement: requirement,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    if (requirements.isEmpty && !isLoading)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text('No Requirements'),
                          ),
                        ],
                      ),
                    if (isLoading && requirements.isEmpty)
                      const Center(
                        child: LoadingAnimation(),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
                Positioned(
                  right: 30,
                  bottom: 30,
                  child: GestureDetector(
                    onTap: () {
                      if (subscription != 'free') {
                        _openModalSheet(sheet: 'requirement');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const UpgradeDialog(),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF004797),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPost(
      {bool withImage = false, required Requirement requirement}) {
    String formattedDateTime = DateFormat('h:mm a · MMM d, yyyy')
        .format(DateTime.parse(requirement.createdAt.toString()).toLocal());

    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        final asyncRequirementOwner = ref.watch(
            fetchUserDetailsProvider(token, requirement.author?.id ?? ''));

        return asyncRequirementOwner.when(
          data: (requirementOwner) {
            final receiver = Participant(
                firstName: requirementOwner.name?.firstName ?? '',
                middleName: requirementOwner.name?.middleName ?? '',
                lastName: requirementOwner.name?.lastName ?? '',
                id: requirementOwner.id,
                profilePicture: requirementOwner.profilePicture);

            return GestureDetector(
              onTap: () {
                showRequirementModalSheet(
                    context: context,
                    onButtonPressed: () {},
                    buttonText: 'MESSAGE',
                    requirement: requirement,
                    sender: Participant(id: id),
                    receiver: receiver);
              },
              child: Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: asyncUser.when(
                  loading: () => Center(child: ReusableFeedPostSkeleton()),
                  error: (error, stackTrace) {
                    // Handle error state
                    return Center(
                      child: ReusableFeedPostSkeleton(),
                    );
                  },
                  data: (user) {
                    if (requirement.author != null) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 10, top: 20),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    child: Image.network(
                                      receiver.profilePicture ??
                                          '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/icons/dummy_person_small.png');
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${requirement.author?.name?.firstName ?? ''} ${requirement.author?.name?.middleName ?? ''} ${requirement.author?.name?.lastName ?? ''}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formattedDateTime,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    if (requirementOwner.id != id)
                                      CustomDropDown(
                                        isBlocked: false,
                                        requirement: requirement,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (withImage) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight:
                                        400, // Adjust as needed for max display size
                                  ),
                                  child: Image.network(
                                    requirement.image!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      // While the image is loading, show shimmer effect
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                  ),
                                ),
                              );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      requirement.content ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            );
          },
          loading: () => Center(child: ReusableFeedPostSkeleton()),
          error: (error, stackTrace) {
            log('$stackTrace');
            return Center(
              child: Text(error.toString()),
            );
          },
        );
      },
    );
  }
}
