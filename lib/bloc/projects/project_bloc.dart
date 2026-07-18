import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/project_model.dart';
import '../../repository/project_repository.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository repository;

  List<ProjectModel> _allProjects = [];

  String _searchQuery = "";
  String _district = "All";
  String _authority = "All";
  String _status = "All";
  bool _ascending = true;

  ProjectBloc(this.repository) : super(const ProjectInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<SearchProjects>(_onSearchProjects);
    on<FilterByDistrict>(_onFilterByDistrict);
    on<FilterByAuthority>(_onFilterByAuthority);
    on<FilterByStatus>(_onFilterByStatus);
    on<SortProjects>(_onSortProjects);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectLoading());

    try {
      _allProjects = await repository.loadProjects();
      _applyFilters(emit);
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  void _onSearchProjects(
    SearchProjects event,
    Emitter<ProjectState> emit,
  ) {
    _searchQuery = event.query;
    _applyFilters(emit);
  }

  void _onFilterByDistrict(
    FilterByDistrict event,
    Emitter<ProjectState> emit,
  ) {
    _district = event.district;
    _applyFilters(emit);
  }

  void _onFilterByAuthority(
    FilterByAuthority event,
    Emitter<ProjectState> emit,
  ) {
    _authority = event.authority;
    _applyFilters(emit);
  }

  void _onFilterByStatus(
    FilterByStatus event,
    Emitter<ProjectState> emit,
  ) {
    _status = event.status;
    _applyFilters(emit);
  }

  void _onSortProjects(
    SortProjects event,
    Emitter<ProjectState> emit,
  ) {
    _ascending = event.ascending;
    _applyFilters(emit);
  }

  void _applyFilters(
    Emitter<ProjectState> emit,
  ) {
    List<ProjectModel> filtered = List.from(_allProjects);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        return project.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_district != "All") {
      filtered = filtered.where((project) {
        return project.district == _district;
      }).toList();
    }

    if (_authority != "All") {
      filtered = filtered.where((project) {
        return project.authority == _authority;
      }).toList();
    }

    if (_status != "All") {
      filtered = filtered.where((project) {
        return project.status == _status;
      }).toList();
    }

    filtered.sort((a, b) {
      return _ascending
          ? a.progress.compareTo(b.progress)
          : b.progress.compareTo(a.progress);
    });

    emit(ProjectLoaded(filtered));
  }
}