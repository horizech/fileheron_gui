import 'package:apiraiser/apiraiser.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/subjects.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/apiraiser/repositories/project.dart';

class ProjectBloc {
  final repository = ProjectRepository();

  final PublishSubject<List<Project>?> _projectsFetcher =
      PublishSubject<List<Project>?>();
  Stream<List<Project>?> get stream$ => _projectsFetcher.stream;

  /// Delete project
  Future<APIResult> deleteProject(String projectId) async {
    APIResult result = await repository.deleteProject(projectId);
    return result;
  }

  /// Get projects
  Future<List<Project>?> getProjects() async {
    List<Project>? result = await repository.getProjects();
    _projectsFetcher.sink.add(result);
    return result;
  }

  /// Insert project
  Future<APIResult> insertProject(Project project) async {
    APIResult result = await repository.insertProject(project);
    return result;
  }

  /// Update project
  Future<APIResult> updateProject(Project project) async {
    APIResult result = await repository.updateProject(project);
    return result;
  }

  clear() {
    _projectsFetcher.sink.add([]);
    //dispose();
  }

  dispose() {
    _projectsFetcher.close();
  }
}

final ProjectBloc projectBloc = ProjectBloc();
