import 'package:flutter/material.dart';
import 'ticket_dialog.dart';
import '../data/ticket_history.dart';


class TicketPage extends StatefulWidget {
  const TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final TextEditingController _detailController = TextEditingController();
  String? _selectedReason;
  final List<String> _reasons = [
    'Đi học trễ',
    'Không logo',
    'Không bảng tên',
  ];

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

Future<void> _showTicketDialog() async {
  final result = await showDialog<Map<String, String>>(
    context: context,
    builder: (_) => const TicketDialog(),
  );

  if (result != null) {
    setState(() {
      final now = DateTime.now();

      TicketHistory.tickets.insert(0, {
        "username": "NguyenHaTuanAnh", // sau này lấy từ tài khoản đăng nhập
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã gửi ticket"),
      ),
    );
  }
}

  void _submitTicket() {
    final selected = _selectedReason ?? 'Chưa chọn';
    final detail = _detailController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi ticket: $selected${detail.isNotEmpty ? '\n$detail' : ''}'),
      ),
    );
    _detailController.clear();
    setState(() {
      _selectedReason = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Gửi ticket khi vi phạm nội quy:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _showTicketDialog,
              child: const Text('Gửi ticket'),
            ),

            const SizedBox(height: 20),

            const Text(
              "Lịch sử gửi ticket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
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
              ),
            ),
          ],
        )
      ),
    );
  }
}
