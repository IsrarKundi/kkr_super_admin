import 'package:flutter/material.dart';

class TopUserList extends StatelessWidget {
  const TopUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Roselle Ehrman', 'email': 'quasiah@gmail.com'},
      {'name': 'Jone Smith', 'email': 'fellora@mail.ru'},
      {'name': 'Theresa', 'email': 'codience@gmail.com'},
      {'name': 'Audrey', 'email': 'warn@mail.ru'},
      {'name': 'Brandie', 'email': 'dric@gmail.com'},
      {'name': 'Bessie', 'email': 'icadahil@gmail.com'},
      {'name': 'Leatrice Kulik', 'email': 'lline@wandex.ru'},
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(left: 5, right: 32, top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top User',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),
          ...users.map((user) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFc89849).withOpacity(0.12),
                  child: Text(
                    user['name']![0],
                    style: const TextStyle(
                      color: Color(0xFFc89849),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name']!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      user['email']!,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
} 