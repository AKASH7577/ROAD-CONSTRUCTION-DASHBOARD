import 'package:flutter/material.dart';

import '../models/project_model.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onView;

  const ProjectCard({
    super.key,
    required this.project,
    this.onView,
  });

  Color _getStatusColor() {
    switch (project.status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      elevation: 5,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Project Name + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: statusColor.withValues(alpha: .15),
                  side: BorderSide.none,
                  label: Text(
                    project.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(project.district)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.account_balance,
                    color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(project.authority)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.engineering,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(project.contractor)),
              ],
            ),

            const Divider(height: 30),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.currency_rupee,
                          color: Colors.green),
                      const SizedBox(height: 4),
                      Text(
                        "₹${project.budget.toStringAsFixed(0)} Cr",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Budget",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.straight,
                          color: Colors.blue),
                      const SizedBox(height: 4),
                      Text(
                        "${project.length} km",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Length",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progress",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${project.progress}%",
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: project.progress / 100,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    AlwaysStoppedAnimation(statusColor),
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: onView,
                icon: const Icon(Icons.visibility),
                label: const Text("View Details"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}