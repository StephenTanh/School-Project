import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TicketDialog extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const TicketDialog({super.key, required this.onSubmit});

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final TextEditingController _detailController = TextEditingController();
  late final Future<List<_Student>> _studentsFuture;

  String? _selectedClass;
  String? _selectedStudent;
  final Set<String> _selectedViolations = {};

  final List<String> _violations = [
    'Đi học trễ',
    'Không logo',
    'Không bảng tên',
  ];

  @override
  void initState() {
    super.initState();
    _studentsFuture = _loadStudents();
  }

  Future<List<_Student>> _loadStudents() async {
    final jsonString = await rootBundle.loadString(
      'lib/data/DS_Khoi_11_jsonfile.json',
    );
    final records = jsonDecode(jsonString) as List<dynamic>;
    return records
        .map((record) => _Student.fromJson(record as Map<String, dynamic>))
        .toList();
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _sendTicket() {
    if (_selectedClass == null ||
        _selectedStudent == null ||
        _selectedViolations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn lớp, học sinh và ít nhất một lỗi.'),
        ),
      );
      return;
    }

    widget.onSubmit({
      "student": _selectedStudent!,
      "class": _selectedClass!,
      "reason": _selectedViolations.join(', '),
      "detail": _detailController.text.trim(),
    });

    setState(() {
      _selectedClass = null;
      _selectedStudent = null;
      _selectedViolations.clear();
      _detailController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã gửi ticket")));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_Student>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Không thể tải danh sách học sinh.'),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final students = snapshot.data!;
        final classes =
            students.map((student) => student.className).toSet().toList()
              ..sort();
        final availableStudents = students
            .where(
              (student) =>
                  _selectedClass == null || student.className == _selectedClass,
            )
            .toList();

        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Gửi Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Chọn lớp',
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Có thể chọn trước hoặc sau khi chọn tên'),
                  items: classes
                      .map(
                        (className) => DropdownMenuItem(
                          value: className,
                          child: Text(className),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value;
                      if (_selectedStudent != null &&
                          !students.any(
                            (student) =>
                                student.name == _selectedStudent &&
                                student.className == value,
                          )) {
                        _selectedStudent = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStudent,
                  decoration: const InputDecoration(
                    labelText: 'Chọn tên học sinh',
                    border: OutlineInputBorder(),
                  ),
                  items: availableStudents
                      .map(
                        (student) => DropdownMenuItem(
                          value: student.name,
                          child: Text(student.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStudent = value;
                      if (value != null) {
                        _selectedClass = students
                            .firstWhere((student) => student.name == value)
                            .className;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chọn lỗi vi phạm',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ..._violations.map(
                  (violation) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(violation),
                    value: _selectedViolations.contains(violation),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedViolations.add(violation);
                        } else {
                          _selectedViolations.remove(violation);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _detailController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendTicket,
                    child: const Text('Gửi'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Student {
  final String name;
  final String className;

  const _Student({required this.name, required this.className});

  factory _Student.fromJson(Map<String, dynamic> json) {
    return _Student(
      name: json['name'] as String,
      className: json['class'] as String,
    );
  }
}
