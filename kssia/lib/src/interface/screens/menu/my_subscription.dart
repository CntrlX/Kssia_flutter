import 'package:flutter/material.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          subscriptionCard(
              context, 'Membership subscription', 'Active', '12th July 2025', '₹2000', '12th July 2026'),
          subscriptionCard(
              context, 'App subscription', 'Premium', '12th July 2025', '₹2000', '12th July 2026'),
        ],
      ),
    );
  }

  Widget subscriptionCard(BuildContext context, String subscriptionType, String planStatus,
      String lastRenewedDate, String amount, String dueDate) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subscriptionType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Text('Plan'),
              title: Text(planStatus),
            ),
            ListTile(
              leading: const Text('Last Renewed date'),
              title: Text(lastRenewedDate),
            ),
            ListTile(
              leading: const Text('Amount to be paid'),
              title: Text(amount),
            ),
            ListTile(
              leading: const Text('Due date'),
              title: Text(dueDate),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement upload receipt logic
                },
                child: const Text('UPLOAD RECEIPT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
