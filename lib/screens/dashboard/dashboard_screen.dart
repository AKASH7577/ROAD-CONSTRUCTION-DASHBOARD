import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/analytics/filtered_projects_screen.dart';
import 'package:flutter_assignment/screens/project_details/project_details_screen.dart';
import 'package:flutter_assignment/screens/projects/projects_screen.dart';
import 'package:flutter_assignment/widgets/dashboard_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/projects/project_bloc.dart';
import '../../bloc/projects/project_event.dart';
import '../../bloc/projects/project_state.dart';
import '../../models/project_model.dart';
import '../../repository/project_repository.dart';
import '../../widgets/loading_widget.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectBloc(ProjectRepository())..add(const LoadProjects()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Road Construction Dashboard"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const LoadingWidget();
          }

          if (state is ProjectError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ProjectLoaded) {
            final List<ProjectModel> projects = state.projects;

            final totalProjects = projects.length;

            final completed = projects
                .where((p) => p.status == "Completed")
                .length;

            final inProgress = projects
                .where((p) => p.status == "In Progress")
                .length;

            final pending = projects
                .where((p) => p.status == "Pending")
                .length;

            final totalBudget = projects.fold<double>(
              0,
              (sum, p) => sum + p.budget,
            );

            final totalLength = projects.fold<double>(
              0,
              (sum, p) => sum + p.length,
            );

            final averageProgress = projects.isEmpty
                ? 0
                : projects
                        .map((e) => e.progress)
                        .reduce((a, b) => a + b) /
                    projects.length;

                    return RefreshIndicator(
              onRefresh: () async {
                context.read<ProjectBloc>().add(const LoadProjects());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProjectsScreen(),
                            ),
                          );
                        },
                        child: DashboardCard(
                          title: "Projects",
                          value: "$totalProjects",
                          icon: Icons.folder_copy,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                      const SizedBox(width: 12),
                     Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FilteredProjectsScreen(
                              title: "Completed Projects",
                              projects: projects
                                  .where((p) => p.status == "Completed")
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      child: DashboardCard(
                        title: "Completed",
                        value: "$completed",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                    Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FilteredProjectsScreen(
                              title: "In Progress Projects",
                              projects: projects
                                  .where((p) => p.status == "In Progress")
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      child: DashboardCard(
                        title: "Ongoing",
                        value: "$inProgress",
                        icon: Icons.construction,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                      const SizedBox(width: 12),
                     Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FilteredProjectsScreen(
                                title: "Pending Projects",
                                projects: projects
                                    .where((p) => p.status == "Pending")
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        child: DashboardCard(
                          title: "Pending",
                          value: "$pending",
                          icon: Icons.pending_actions,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.currency_rupee),
                      title: const Text("Total Budget"),
                     subtitle: Text(
                      "₹${totalBudget.toStringAsFixed(0)} Cr",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.route),
                      title: const Text("Road Length"),
                     subtitle: Text(
                    "${totalLength.toStringAsFixed(0)} km",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [

                          const Text(
                            "Overall Progress",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: averageProgress / 100,
                          ),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 14,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: const AlwaysStoppedAnimation(
                                  Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 10),

                          Text(
                            "${averageProgress.toStringAsFixed(1)} %",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recent Projects",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length > 5
                        ? 5
                        : projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
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
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Hero(
                                    tag: project.name,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        "${project.progress}%",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            project.district,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Chip(
                                      label: Text(project.status),
                                      backgroundColor: project.status == "Completed"
                                          ? Colors.green.shade100
                                          : project.status == "In Progress"
                                              ? Colors.orange.shade100
                                              : Colors.red.shade100,
                                    ),

                                    const SizedBox(width: 8),

                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
           );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

