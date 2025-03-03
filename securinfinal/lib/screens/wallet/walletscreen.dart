import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool showFullHistory = false;

  final List<Transaction> transactions = [
    Transaction(
      type: 'Received',
      amount: '0.005',
      date: '2024-03-21',
    ),
    Transaction(
      type: 'Sent',
      amount: '0.003',
      date: '2024-03-20',
    ),
    Transaction(
      type: 'Received',
      amount: '0.008',
      date: '2024-03-19',
    ),
    Transaction(
      type: 'Sent',
      amount: '0.002',
      date: '2024-03-18',
    ),
    Transaction(
      type: 'Received',
      amount: '0.004',
      date: '2024-03-17',
    ),
    Transaction(
      type: 'Sent',
      amount: '0.001',
      date: '2024-03-16',
    ),
    Transaction(
      type: 'Received',
      amount: '0.006',
      date: '2024-03-15',
    ),
    Transaction(
      type: 'Sent',
      amount: '0.003',
      date: '2024-03-14',
    ),
    Transaction(
      type: 'Received',
      amount: '0.007',
      date: '2024-03-13',
    ),
    Transaction(
      type: 'Sent',
      amount: '0.002',
      date: '2024-03-12',
    ),
  ];

  void _showFullHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF000435),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: transaction.type == 'Received'
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    transaction.type == 'Received'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: transaction.type == 'Received'
                                        ? Colors.green
                                        : Colors.red,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  transaction.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${transaction.type == 'Received' ? '+' : '-'}${transaction.amount} ♦',
                                  style: TextStyle(
                                    color: transaction.type == 'Received'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  transaction.date,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedTransactions = transactions.take(5).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF000435),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF000435),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Text('Imtiaz',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Icon(Icons.menu, color: Colors.white),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey,
                          const Color(0xFFE23434),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const Text(
                          '.002♦',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton('Exchange', Icons.swap_horiz),
                            _buildActionButton('History', Icons.history),
                            _buildActionButton('Settings', Icons.settings),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: const Color(0xFF000435),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'History',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      '1 ♦ = 1269 rs',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF000435),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: displayedTransactions.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final transaction = displayedTransactions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: transaction.type == 'Received'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        transaction.type == 'Received'
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: transaction.type == 'Received'
                                            ? Colors.green
                                            : Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      transaction.type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${transaction.type == 'Received' ? '+' : '-'}${transaction.amount} ♦',
                                      style: TextStyle(
                                        color: transaction.type == 'Received'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      transaction.date,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextButton(
                        onPressed: () => _showFullHistory(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Full History',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return GestureDetector(
      onTap: () async {
        if (label == 'History') {
          _showFullHistory(context);
        } else if (label == 'Exchange') {
          final Uri url = Uri.parse('https://www.kraken.com/');
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class Transaction {
  final String type;
  final String amount;
  final String date;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
  });
}