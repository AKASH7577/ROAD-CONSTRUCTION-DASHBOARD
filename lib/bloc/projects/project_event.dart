import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

/// Load all projects
class LoadProjects extends ProjectEvent {
  const LoadProjects();
}

/// Search projects
class SearchProjects extends ProjectEvent {
  final String query;

  const SearchProjects(this.query);

  @override
  List<Object?> get props => [query];
}

/// Filter by district
class FilterByDistrict extends ProjectEvent {
  final String district;

  const FilterByDistrict(this.district);

  @override
  List<Object?> get props => [district];
}

/// Filter by authority
class FilterByAuthority extends ProjectEvent {
  final String authority;

  const FilterByAuthority(this.authority);

  @override
  List<Object?> get props => [authority];
}

/// Filter by status
class FilterByStatus extends ProjectEvent {
  final String status;

  const FilterByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Sort projects
class SortProjects extends ProjectEvent {
  final bool ascending;

  const SortProjects({
    this.ascending = true,
  });

  @override
  List<Object?> get props => [ascending];
}