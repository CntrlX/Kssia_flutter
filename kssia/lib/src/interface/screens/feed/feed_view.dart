import 'package:flutter/material.dart';

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
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search your Products and requirements',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 226, 224, 224),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )),
          SizedBox(height: 16),
          _buildPost(),
          _buildPost(withImage: true),
          _buildPost(withImage: true),
        ],
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
  }

  Widget _buildPost({bool withImage = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lorem ipsum dolor sit amet consectetur. Quis enim nisl ullamcorper tristique integer orci nunc in eget. '
              'Amet hac bibendum dignissim eget pretium turpis in non cum.',
              style: TextStyle(fontSize: 14),
            ),
            if (withImage) ...[
              SizedBox(height: 16),
              Image(
                  image: NetworkImage(
                      'https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133351928-stock-illustration-default-placeholder-man-and-woman.jpg')) // Replace with your image path
            ],
            SizedBox(height: 16),
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/icons/johnkappa_feed.png'), // Replace with your logo image path
                  radius: 16,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Kappa',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      'Company name',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  '12:30 PM - Apr 21, 2021',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
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
