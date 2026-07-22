import 'package:flutter/material.dart';
import 'package:schoolapp2/pages/history.dart';
import 'package:schoolapp2/pages/ticket.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Hello, World!",
              style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(229, 47, 47, 0.5),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicketPage(),
                    ),
                  );
                },
                child: const Text("Gửi Ticket"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}