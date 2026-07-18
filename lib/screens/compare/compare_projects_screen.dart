import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/projects/project_bloc.dart';
import '../../bloc/projects/project_event.dart';
import '../../bloc/projects/project_state.dart';
import '../../models/project_model.dart';
import '../../repository/project_repository.dart';

class CompareProjectsScreen extends StatelessWidget {
  const CompareProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectBloc(ProjectRepository())..add(const LoadProjects()),
      child: const CompareProjectsView(),
    );
  }
}

class CompareProjectsView extends StatefulWidget {
  const CompareProjectsView({super.key});

  @override
  State<CompareProjectsView> createState() =>
      _CompareProjectsViewState();
}

class _CompareProjectsViewState
    extends State<CompareProjectsView> {
  ProjectModel? project1;
  ProjectModel? project2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compare Projects"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(
              child: CircularProgressIndicator(),
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

          project1 ??= projects.first;
          project2 ??=
              projects.length > 1 ? projects[1] : projects.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                DropdownButtonFormField<ProjectModel>(
                  initialValue: project1,
                 decoration: const InputDecoration(
                    labelText: "Select Project 1",
                    border: OutlineInputBorder(),
                  ),
                  items: projects.map((project) {
                    return DropdownMenuItem(
                      value: project,
                      child: Text(project.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      project1 = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<ProjectModel>(
                  initialValue: project2,
                 decoration: const InputDecoration(
                      labelText: "Select Project 2",
                      border: OutlineInputBorder(),
                    ),
                  items: projects.map((project) {
                    return DropdownMenuItem(
                      value: project,
                      child: Text(project.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      project2 = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

              SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 40,
                     horizontalMargin: 20,
                    columns: [
                      const DataColumn(
                        label: Text(
                          "Property",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 140,
                          child: Text(
                            project1!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            project2!.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    rows: [
                  
                      _row(
                        "District",
                        project1!.district,
                        project2!.district,
                      ),
                  
                      _row(
                        "Authority",
                        project1!.authority,
                        project2!.authority,
                      ),
                  
                      _row(
                        "Contractor",
                        project1!.contractor,
                        project2!.contractor,
                      ),
                  
                      _row(
                          "Budget",
                          "₹${project1!.budget.toStringAsFixed(0)} Cr",
                          "₹${project2!.budget.toStringAsFixed(0)} Cr",
                        ),
                  
                      _row(
                        "Length",
                        "${project1!.length} km",
                        "${project2!.length} km",
                      ),
                  
                      _row(
                        "Progress",
                        "${project1!.progress}%",
                        "${project2!.progress}%",
                      ),
                  
                      _row(
                        "Status",
                        project1!.status,
                        project2!.status,
                      ),
                  
                      _row(
                        "Start Date",
                        project1!.startDate,
                        project2!.startDate,
                      ),
                  
                      _row(
                        "End Date",
                        project1!.endDate,
                        project2!.endDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DataRow _row(
    String title,
    String left,
    String right,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(title)),
        DataCell(Text(left)),
        DataCell(Text(right)),
      ],
    );
  }
}