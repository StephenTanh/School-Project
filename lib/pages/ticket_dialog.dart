import 'package:flutter/material.dart';

class TicketDialog extends StatefulWidget {
  const TicketDialog({super.key});

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final TextEditingController _detailController = TextEditingController();

  String? _selectedReason;

  final List<String> _reasons = ['Đi học trễ', 'Không logo', 'Không bảng tên'];

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gửi Ticket"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedReason,
            decoration: const InputDecoration(labelText: "Chọn lý do"),
            items: _reasons.map((reason) {
              return DropdownMenuItem(value: reason, child: Text(reason));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedReason = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _detailController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "Chi tiết",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _selectedReason == null
              ? null
              : () {
                  Navigator.pop(context, {
                    "reason": _selectedReason!,
                    "detail": _detailController.text.trim(),
                  });
                },
          child: const Text("Gửi"),
        ),
      ],
    );
  }
}
