import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProductPage extends StatelessWidget {
  const MyProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
              // WhatsApp icon action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _InfoCard(title: 'Products', count: '30'),
                _InfoCard(title: 'Messages', count: '30'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const _ProductCard();
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 170,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const _ProductDetailSheet();
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Row(
                    children: [
                      const Text(
                        'Add Products',
                        style: TextStyle(
                          color: Colors.white, // Change text color to white
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004797), // Button color
                    minimumSize: const Size(double.infinity, 55), // Smaller height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String count;

  const _InfoCard({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // Adjust the padding to give more space inside the card
      width: 150, // Width can be adjusted based on your design needs
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12, // Smaller font size for the title
              fontWeight: FontWeight.w500, // Medium font weight
              color: Colors.grey, // Lighter color for the title text
            ),
          ),
          const SizedBox(height: 4), // Smaller spacing between title and count
          Text(
            count,
            style: const TextStyle(
              fontSize: 28, // Larger font size for the count
              fontWeight: FontWeight.bold, // Bold font weight for emphasis
              color: Colors.black, // Dark color for the count text
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.grey[300], // Placeholder for image
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(0.005), // Smaller padding to fit the icon better
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // More options action
                    },
                    iconSize: 20,  // Adjusted icon size to match the design
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 4),
                Text(
                  'Plastic Cartons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '₹2000 ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red, // Red color for strike-through
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                      TextSpan(
                        text: '₹1224',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF004797),
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black, // Black background for the price
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'MOQ: 100',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailSheet extends StatelessWidget {
  const _ProductDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.grey[300], // Placeholder for image
              ),
              const SizedBox(height: 16),
              Text(
                'Plastic Cartons',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'INR 2000 ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red, // Red color for strike-through
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                    TextSpan(
                      text: ' INR 1499.00 / piece',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black, // Black background for the price
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'MOQ: 100',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey, // Placeholder for user image
                  ),
                  SizedBox(width: 8),
                  Text(
                    'John Kappa',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    '24 Reviews',
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.star, color: Colors.yellow, size: 16), // Yellow star for rating
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                  Icon(Icons.star_half, color: Colors.yellow, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '3 messages',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF004797),
                  decoration: TextDecoration.underline, // Underline for the text
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
