import 'package:flutter/material.dart';

class MyTransactionsPage extends StatefulWidget {
  const MyTransactionsPage({Key? key}) : super(key: key);

  @override
  _MyTransactionsPageState createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _transactionList('All'),
          _transactionList('Approved'),
          _transactionList('Rejected'),
        ],
      ),
    );
  }

  Widget _transactionList(String status) {
    return ListView.builder(
      itemCount: 5, // Number of transactions, you can adjust as needed
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Transaction ID: VCRU6578990${index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: App subscription'),
                Text('Date & time: 12th July 2025, 12:20 pm'),
                Text('Amount paid: ₹2000'),
                Text('Status: ${status == 'All' ? (index % 2 == 0 ? 'Approved' : 'Rejected') : status}'),
                if (status == 'Rejected')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Reason for rejection: Lorem ipsum dolor sit amet'),
                      Text('Description: Lorem ipsum dolor sit amet consectetur...'),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: null, // Implement re-upload logic
                        child: Text('RE-UPLOAD'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
