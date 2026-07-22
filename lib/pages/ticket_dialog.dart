import 'package:flutter/material.dart';

class TicketDialog extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const TicketDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
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

  void _sendTicket() {
    if (_selectedReason == null) return;

    widget.onSubmit({
      "reason": _selectedReason!,
      "detail": _detailController.text.trim(),
    });

    setState(() {
      _selectedReason = null;
      _detailController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã gửi ticket")));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Gửi Ticket",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: const InputDecoration(
                labelText: "Chọn lý do",
                border: OutlineInputBorder(),
              ),
              items: _reasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _detailController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Chi tiết",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedReason == null ? null : _sendTicket,
                child: const Text("Gửi"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}