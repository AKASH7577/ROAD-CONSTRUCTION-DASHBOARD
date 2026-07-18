import 'package:flutter/material.dart';

import '../../models/project_model.dart';
import '../project_details/project_details_screen.dart';

class FilteredProjectsScreen extends StatelessWidget {
  final String title;
  final List<ProjectModel> projects;

  const FilteredProjectsScreen({
    super.key,
    required this.title,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: projects.isEmpty
          ? const Center(
              child: Text(
                "No Projects Found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text("${project.progress}%"),
                    ),
                    title: Text(project.name),
                    subtitle: Text(project.district),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailsScreen(
                            project: project,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}