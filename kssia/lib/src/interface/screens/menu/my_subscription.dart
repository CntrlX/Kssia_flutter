import 'package:flutter/material.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscription'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          subscriptionCard(context, 'Membership subscription', 'Active', '12th July 2025', '₹2000', '12th July 2026', Colors.green),
          subscriptionCard(context, 'App subscription', 'Premium', '12th July 2025', '₹2000', '12th July 2026', Colors.red),
        ],
      ),
    );
  }
}

  Widget subscriptionCard(BuildContext context, String subscriptionType, String planStatus,
        String lastRenewedDate, String amount, String dueDate, Color statusColor) {
      return Card(
        margin: const EdgeInsets.all(20),
        elevation: 4,
        shadowColor: const Color.fromARGB(255, 194, 194, 194).withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subscriptionType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, // Fill color
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                        border: Border.all(color: subscriptionType == 'Membership subscription' ? Colors.green : Colors.orange), // Outline color
                      ),
                      child: Text(
                        subscriptionType == 'Membership subscription' ? 'Active' : 'Premium',
                        style: TextStyle(
                          color: subscriptionType == 'Membership subscription' ? Colors.green : Colors.orange, // Font color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              detailRow('Last Renewed date', lastRenewedDate),
              detailRow('Amount to be paid', amount),
              detailRow('Due date', dueDate),
              const SizedBox(height: 16),
                Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004797),
                  foregroundColor: Colors.white, // Corrected from 'onPrimary'
                  minimumSize: const Size.fromHeight(50), // specifying the height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Set the border radius to 4
                  ),
                  ),
                  onPressed: () => _showUploadModal(context),
                  child: const Text('UPLOAD RECEIPT'),
                ),
                ),
            ],
          ),
        ),
      );
    }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 16))),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Payment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 40, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Upload Receipt',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
                ElevatedButton(
                onPressed: () {
                  // Handle post requirement
                },
                child: Text('SAVE', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004797), // Set to AppPalette.kPrimaryColor
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Set the border radius to 4
                  ),
                ),
                ),
            ],
          ),
        );
      },
    );
  }
  