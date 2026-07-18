import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/authority/authority_projects_screen.dart';
import 'package:flutter_assignment/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/projects/project_bloc.dart';
import '../../bloc/projects/project_event.dart';
import '../../bloc/projects/project_state.dart';
import '../../models/project_model.dart';
import '../../repository/project_repository.dart';

class AuthorityPerformanceScreen extends StatelessWidget {
  const AuthorityPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectBloc(ProjectRepository())..add(const LoadProjects()),
      child: const AuthorityPerformanceView(),
    );
  }
}

class AuthorityPerformanceView extends StatelessWidget {
  const AuthorityPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authority Performance"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          if (state is ProjectError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is! ProjectLoaded) {
            return const SizedBox();
          }

          final projects = state.projects;

          final Map<String, List<ProjectModel>> authorityProjects = {};

          for (final project in projects) {
            authorityProjects.putIfAbsent(
              project.authority,
              () => [],
            );

            authorityProjects[project.authority]!.add(project);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: authorityProjects.length,
            itemBuilder: (context, index) {
              final authority =
                  authorityProjects.keys.elementAt(index);

              final list = authorityProjects[authority]!;

              final totalProjects = list.length;

              final completed = list
                  .where((p) => p.status == "Completed")
                  .length;

              final avgProgress = list
                      .map((e) => e.progress)
                      .reduce((a, b) => a + b) /
                  totalProjects;

              final totalBudget = list.fold<double>(
                0,
                (sum, p) => sum + p.budget,
              );

              return Card(
             
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthorityProjectsScreen(
                          authority: authority,
                          projects: list,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          authority,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(Icons.folder),
                            const SizedBox(width: 10),
                            Text("Projects : $totalProjects"),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            Text("Completed : $completed"),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Budget : ₹${totalBudget.toStringAsFixed(2)} Cr",
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Average Progress",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: avgProgress / 100,
                          ),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 10,
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${avgProgress.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              );
            },
          );
        },
      ),
    );
  }
}