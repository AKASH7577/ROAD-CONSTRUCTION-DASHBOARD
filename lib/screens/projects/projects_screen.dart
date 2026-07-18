import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/projects/project_bloc.dart';
import '../../bloc/projects/project_event.dart';
import '../../bloc/projects/project_state.dart';
import '../../models/project_model.dart';
import '../../repository/project_repository.dart';
import '../../widgets/project_card.dart';
import '../project_details/project_details_screen.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_widget.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectBloc(ProjectRepository())..add(const LoadProjects()),
      child: const ProjectsView(),
    );
  }
}

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final TextEditingController searchController = TextEditingController();

  String selectedDistrict = "All";
  String selectedAuthority = "All";
  String selectedStatus = "All";

  bool ascending = true;

  final List<String> districts = const [
    "All",
    "Mumbai",
    "Pune",
    "Nagpur",
  ];

  final List<String> authorities = const [
    "All",
    "NHAI",
    "PWD",
    "MSRDC",
  ];

  final List<String> statuses = const [
    "All",
    "Completed",
    "In Progress",
    "Pending",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          /// Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search Project",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<ProjectBloc>().add(
                      SearchProjects(value),
                    );
              },
            ),
          ),

          /// Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [

                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedDistrict,
                    decoration: const InputDecoration(
                      labelText: "District",
                      border: OutlineInputBorder(),
                    ),
                    items: districts
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedDistrict = value;
                      });

                      context.read<ProjectBloc>().add(
                            FilterByDistrict(value),
                          );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedAuthority,
                    decoration: const InputDecoration(
                      labelText: "Authority",
                      border: OutlineInputBorder(),
                    ),
                    items: authorities
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedAuthority = value;
                      });

                      context.read<ProjectBloc>().add(
                            FilterByAuthority(value),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      Expanded(
        child: DropdownButtonFormField<String>(
          initialValue: selectedStatus,
          decoration: const InputDecoration(
            labelText: "Status",
            border: OutlineInputBorder(),
          ),
          items: statuses
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedStatus = value;
            });

            context.read<ProjectBloc>().add(
              FilterByStatus(value),
            );
          },
        ),
      ),

      const SizedBox(width: 10),

      SizedBox(
        width: 110,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              ascending = !ascending;
            });

            context.read<ProjectBloc>().add(
              SortProjects(
                ascending: ascending,
              ),
            );
          },
          icon: const Icon(Icons.sort),
          label: Text(
            ascending ? "Asc" : "Desc",
          ),
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 15),

          Expanded(
            child: BlocBuilder<ProjectBloc, ProjectState>(
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
                  if (state.projects.isEmpty) {
                      return const EmptyWidget(
                      message: "No Projects Found",
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: state.projects.length,
                    itemBuilder: (context, index) {
                      final ProjectModel project =
                          state.projects[index];

                      return ProjectCard(
                        project: project,
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProjectDetailsScreen(
                                project: project,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}