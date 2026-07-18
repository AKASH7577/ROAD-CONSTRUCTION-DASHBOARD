import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/analytics/filtered_projects_screen.dart';
import 'package:flutter_assignment/screens/project_details/project_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/projects/project_bloc.dart';
import '../../bloc/projects/project_event.dart';
import '../../bloc/projects/project_state.dart';
import '../../models/project_model.dart';
import '../../repository/project_repository.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_widget.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProjectBloc(ProjectRepository())..add(const LoadProjects()),
      child: const AnalyticsView(),
    );
  }
}

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Center(
              child:   LoadingWidget()
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

          final List<ProjectModel> projects = state.projects;


         final completedProjects =
              projects.where((p) => p.status == "Completed").toList();

          final ongoingProjects =
              projects.where((p) => p.status == "In Progress").toList();

          final pendingProjects =
              projects.where((p) => p.status == "Pending").toList();

          final completed = completedProjects.length;
          final ongoing = ongoingProjects.length;
          final pending = pendingProjects.length;
          final monthlyData = [
            FlSpot(1, 15),
            FlSpot(2, 25),
            FlSpot(3, 38),
            FlSpot(4, 52),
            FlSpot(5, 63),
            FlSpot(6, 78),
            FlSpot(7, 90),
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                const Text(
                  "Project Progress",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 30),

                  const Text(
                    "Monthly Completion",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 280,
                        child: LineChart(
                          LineChartData(
                            minX: 1,
                            maxX: 7,
                            minY: 0,
                            maxY: 100,

                            gridData: const FlGridData(show: true),

                            borderData: FlBorderData(show: false),

                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const months = [
                                      "",
                                      "Jan",
                                      "Feb",
                                      "Mar",
                                      "Apr",
                                      "May",
                                      "Jun",
                                      "Jul"
                                    ];

                                    return Text(
                                      months[value.toInt()],
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: monthlyData,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 4,

                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withValues(alpha: 0.15),
                                ),

                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      alignment: BarChartAlignment.spaceAround,

                      barTouchData: BarTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            return;
                          }

                          final int index = response.spot!.touchedBarGroupIndex;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailsScreen(
                                project: projects[index],
                              ),
                            ),
                          );
                        },
                      ),

                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: true),

                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= projects.length) {
                                return const SizedBox();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  projects[value.toInt()].district,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      barGroups: List.generate(
                        projects.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: projects[index].progress.toDouble(),
                              width: 22,
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Project Status",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 280,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 45,
                      sectionsSpace: 3,
                      sections: [

                        PieChartSectionData(
                          value: completed.toDouble(),
                          color: Colors.green,
                          radius: 75,
                          title: "$completed",
                        ),

                        PieChartSectionData(
                          value: ongoing.toDouble(),
                          color: Colors.orange,
                          radius: 75,
                          title: "$ongoing",
                        ),

                        PieChartSectionData(
                          value: pending.toDouble(),
                          color: Colors.red,
                          radius: 75,
                          title: "$pending",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                  title: const Text("Completed"),
                  trailing: Text("$completed"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilteredProjectsScreen(
                          title: "Completed Projects",
                          projects: completedProjects,
                        ),
                      ),
                    );
                  },
                ),
              ),

               Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                  ),
                  title: const Text("In Progress"),
                  trailing: Text("$ongoing"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilteredProjectsScreen(
                          title: "In Progress Projects",
                          projects: ongoingProjects,
                        ),
                      ),
                    );
                  },
                ),
              ),
                            Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                  title: const Text("Pending"),
                  trailing: Text("$pending"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilteredProjectsScreen(
                          title: "Pending Projects",
                          projects: pendingProjects,
                        ),
                      ),
                    );
                  },
                ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }
}