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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
            requirementImage: _requirementImage,
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
        if (!isLoading) {
          return Scaffold(
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search your requirements',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 16),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: requirements.length,
                  itemBuilder: (context, index) {
                    final requirement = requirements[index];
                    if (requirement.status == 'approved') {
                      return _buildPost(
                        withImage: requirement.image != null &&
                            requirement.image!.isNotEmpty,
                        requirement: requirement,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openModalSheet(sheet: 'requirement'),
              label: const Text(
                'Add Requirement/update',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 27,
              ),
              backgroundColor: const Color(0xFF004797),
            ),
          );
        } else {
          return ReusableFeedPostSkeleton();
        }
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
        final asyncRequirementOwner =
            ref.watch(fetchUserDetailsProvider(token, requirement.author!.id!));
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
                      print(user);
                      if (requirement.author != null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (withImage) ...[
                                SizedBox(height: 16),
                                AspectRatio(
                                  aspectRatio: 4 / 4,
                                  child: Image.network(
                                    fit: BoxFit.contain,
                                    requirement.image!,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                          fit: BoxFit.cover,
                                          'https://placehold.co/600x400');
                                    },
                                  ),
                                )
                              ],
                              SizedBox(height: 16),
                              Text(
                                requirement.content!,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Image.network(
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.person);
                                        },
                                        user.profilePicture!, // Replace with your image URL
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${requirement.author!.name!.firstName} ${requirement.author!.name!.middleName} ${requirement.author!.name!.lastName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        user.companyName!,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        formattedDateTime,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      if (requirementOwner.id != id)
                                        CustomDropDown(
                                          requirement: requirement,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else
                        return SizedBox();
                    },
                  )),
            );
          },
          loading: () => Center(child: ReusableFeedPostSkeleton()),
          error: (error, stackTrace) {
            return Center(
              child: Text('NO PROMOTIONS YET'),
            );
          },
        );
      },
    );
  }
}
