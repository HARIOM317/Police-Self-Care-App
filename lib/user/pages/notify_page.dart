import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatelessWidget {
  const NotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10, // You can replace this with your notification count
        itemBuilder: (context, index) {
          return NotificationCard(
            key: Key('notification-$index'),
            title: 'Notification Title',
            subtitle: 'Notification Subtitle',
            time: '10:00 AM', // Replace with actual time
            onPressed: () {
              // Add action on notification click
              if (kDebugMode) {
                print('Notification Clicked');
              }
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Function()? onPressed;

  const NotificationCard({
    required Key key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(subtitle),
            trailing: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}