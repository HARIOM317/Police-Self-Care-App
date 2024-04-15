import 'package:flutter/material.dart';

class ReminderAndNoticePage extends StatelessWidget {
  const ReminderAndNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder & Notice'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ReminderCard(
              key: Key('reminder-1'),
              title: 'Meeting with Team',
              description: 'Discuss project updates',
              time: '10:00 AM',
            ),
            ReminderCard(
              key: Key('reminder-2'),
              title: 'Submit Report',
              description: 'Deadline: Tomorrow',
              time: '2:00 PM',
            ),
            SizedBox(height: 16),
            Text(
              'Notices',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            NoticeCard(
              key: Key('notice-1'),
              title: 'Office Closure',
              description: 'Office will remain closed on Friday.',
            ),
            NoticeCard(
              key: Key('notice-2'),
              title: 'New Policy Announcement',
              description: 'Please read the updated company policy document.',
            ),
          ],
        ),
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const ReminderCard({
    required Key key,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  final String title;
  final String description;

  const NoticeCard({
    required Key key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}