import 'package:flutter/material.dart';
import 'package:flutter_assignment/widgets/info_tile.dart';

import '../../models/project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              Center(
                child: Column(
                  children: [

                    Hero(
                      tag: project.name,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          "${project.progress}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      project.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ),


                const SizedBox(height: 20),

                InfoTile(
                  icon: Icons.location_city,
                  title: "District",
                  value: project.district,
                ),

                   InfoTile(
                  icon: Icons.account_balance,
                  title: "Authority",
                  value: project.authority,
                ),

                  InfoTile(
                  icon: Icons.engineering,
                  title: "Contractor",
                  value: project.contractor,
                ),
                  InfoTile(
                  icon: Icons.currency_rupee,
                  title: "Budget",
                  value: "₹${project.budget}",
                ),

                  InfoTile(
                  icon: Icons.straighten,
                  title: "Road Length",
                  value: "${project.length} km",
                ),

                  InfoTile(
                  icon: Icons.calendar_month,
                  title: "Start Date",
                  value: project.startDate,
                ),

                   InfoTile(
                  icon: Icons.event_available,
                  title: "End Date",
                  value: project.endDate,
                ),

                const SizedBox(height: 25),

                const Text(
                  "Overall Progress",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: project.progress / 100,
                  minHeight: 10,
                ),

                const SizedBox(height: 10),

                Text(
                  "${project.progress}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Materials Used",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                ...project.materials.map(
                  (material) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: Text(material),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}