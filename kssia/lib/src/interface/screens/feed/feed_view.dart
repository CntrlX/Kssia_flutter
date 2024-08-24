import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/requirement_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/interface/common/loading.dart';

class FeedView extends StatelessWidget {
  void _showAddRequirementSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Post a Requirement/update',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 27, color: Color(0xFF004797)),
                        SizedBox(height: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                              color: Color.fromARGB(255, 102, 101, 101)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: ((MediaQuery.sizeOf(context).height) / 200).toInt(),
                decoration: InputDecoration(
                  hintText: 'Add content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    // Handle post requirement
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF004797)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF004797)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Color(0xFF004797)),
                      ),
                    ),
                  ),
                  child: const Text(
                    'POST REQUIREMENT/UPDATE',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncRequirements = ref.watch(fetchRequirementsProvider(token));
        return Scaffold(
          body: asyncRequirements.when(
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              // Handle error state
              return Center(
                child: Text('Error loading promotions: $error'),
              );
            },
            data: (requirements) {
              print(requirements);
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search your Products and requirements',
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
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddRequirementSheet(context),
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
      },
    );
  }

  Widget _buildPost(
      {bool withImage = false, required Requirement requirement}) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: asyncUser.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('Error loading promotions: $error'),
                );
              },
              data: (user) {
                print(user);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (withImage) ...[
                        SizedBox(height: 16),
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            fit: BoxFit.cover,
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
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person);
                                },
                                user.profilePicture!, // Replace with your image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${requirement.author!.name!.firstName} ${requirement.author!.name!.middleName} ${requirement.author!.name!.lastName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                user.companyName!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            requirement.createdAt.toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final String authorName;
  final String companyName;
  final String timestamp;
  final String content;
  final String imagePath;

  PostWidget({
    required this.authorName,
    required this.companyName,
    required this.timestamp,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Image(image: NetworkImage(imagePath)),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/avatar.png'), // Replace with your avatar image path
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(companyName),
                ],
              ),
              Spacer(),
              Text(timestamp),
            ],
          ),
        ],
      ),
    );
  }
}
