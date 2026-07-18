import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Road Project Completed",
      "message": "Mumbai Ring Road has been completed successfully.",
      "time": "10 min ago",
      "icon": Icons.check_circle,
      "color": Colors.green,
      "read": false,
    },
    {
      "title": "Budget Approved",
      "message": "₹120 Cr approved for Pune Highway Expansion.",
      "time": "1 hour ago",
      "icon": Icons.account_balance_wallet,
      "color": Colors.blue,
      "read": true,
    },
    {
      "title": "Progress Updated",
      "message": "Nagpur Bypass progress reached 80%.",
      "time": "3 hours ago",
      "icon": Icons.trending_up,
      "color": Colors.orange,
      "read": false,
    },
    {
      "title": "Project Delayed",
      "message": "Bridge construction delayed due to heavy rainfall.",
      "time": "Yesterday",
      "icon": Icons.warning_amber_rounded,
      "color": Colors.red,
      "read": true,
    },
    {
      "title": "New Project Assigned",
      "message": "New expressway project has been assigned to NHAI.",
      "time": "2 days ago",
      "icon": Icons.assignment,
      "color": Colors.purple,
      "read": false,
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification["read"] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications marked as read"),
      ),
    );
  }

  void markAsRead(int index) {
    if (!(notifications[index]["read"] as bool)) {
      setState(() {
        notifications[index]["read"] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notification marked as read"),
        ),
      );
    }
  }

  void deleteNotification(int index) {
    final title = notifications[index]["title"];

    setState(() {
      notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$title deleted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            icon: const Icon(Icons.done_all),
            onPressed: markAllAsRead,
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Dismissible(
                  key: Key(item["title"]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => deleteNotification(index),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () => markAsRead(index),
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor:
                            (item["color"] as Color).withValues(alpha: 0.15),
                        child: Icon(
                          item["icon"] as IconData,
                          color: item["color"] as Color,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["title"] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: (item["read"] as bool)
                                    ? Colors.black87
                                    : Colors.blue.shade900,
                              ),
                            ),
                          ),
                          if (!(item["read"] as bool))
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["message"] as String),
                            const SizedBox(height: 8),
                            Text(
                              item["time"] as String,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == "read") {
                            markAsRead(index);
                          } else if (value == "delete") {
                            deleteNotification(index);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: "read",
                            child: Row(
                              children: [
                                Icon(Icons.done, size: 18),
                                SizedBox(width: 8),
                                Text("Mark as Read"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: [
                                Icon(Icons.delete,
                                    color: Colors.red, size: 18),
                                SizedBox(width: 8),
                                Text("Delete"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}