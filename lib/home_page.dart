import 'package:flutter/material.dart';
import 'package:schoolapp2/pages/ticket_dialog.dart';
import 'package:schoolapp2/data/ticket_history.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<void> _showTicketDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const TicketDialog(),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        final now = DateTime.now();

        TicketHistory.tickets.insert(0, {
          "username": widget.username,
          "reason": result["reason"]!,
          "detail": result["detail"]!,
          "date":
              "${now.day.toString().padLeft(2, '0')}/"
              "${now.month.toString().padLeft(2, '0')}/"
              "${now.year}",
          "time":
              "${now.hour.toString().padLeft(2, '0')}:"
              "${now.minute.toString().padLeft(2, '0')}",
        });
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã gửi ticket")));
    }
  }

  Widget _buildHomeTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Hello, World!",
            style: TextStyle(
              fontSize: 24,
              color: Color.fromRGBO(229, 47, 47, 0.5),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTicketTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showTicketDialog,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Gửi Ticket'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (TicketHistory.tickets.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có ticket nào được gửi.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: TicketHistory.tickets.length,
      itemBuilder: (context, index) {
        final ticket = TicketHistory.tickets[index];
        return Card(
          child: ListTile(
            title: Text(ticket["reason"]!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket["detail"] ?? ""),
                const SizedBox(height: 5),
                Text("Người gửi: ${ticket["username"]}"),
                Text("${ticket["time"]} - ${ticket["date"]}"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildHomeTab(), _buildTicketTab(), _buildHistoryTab()];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Home'
              : _selectedIndex == 1
              ? 'Ticket'
              : 'History',
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Ticket'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
