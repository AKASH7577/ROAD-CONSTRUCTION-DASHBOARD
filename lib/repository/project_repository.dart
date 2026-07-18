import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/project_model.dart';

class ProjectRepository {
  Future<List<ProjectModel>> loadProjects() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/projects.json',
      );

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList
          .map(
            (e) => ProjectModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      throw Exception(
        "Unable to load projects : $e",
      );
    }
  }
}