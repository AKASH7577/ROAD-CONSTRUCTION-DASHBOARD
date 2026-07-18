import 'package:equatable/equatable.dart';

import '../../models/project_model.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

/// Loading State
class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

/// Loaded State
class ProjectLoaded extends ProjectState {
  final List<ProjectModel> projects;

  const ProjectLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

/// Error State
class ProjectError extends ProjectState {
  final String message;

  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}