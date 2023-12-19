import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';

class ProjectRepository {
  /// Get Projects
  Future<List<Project>?> getProjects() async {
    try {
      APIResult result = await Apiraiser.data.get("Fileheron_Projects");
      if (result.success &&
          result.data != null &&
          (result.data as List<dynamic>).isNotEmpty) {
        List<Project> project = (result.data as List<dynamic>)
            .map((c) => Project.fromJson(c as Map<String, dynamic>))
            .toList();

        return project;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Insert Project
  Future<APIResult> insertProject(Project project) async {
    try {
      return await Apiraiser.data
          .insert("Fileheron_Projects", project.toJson());
    } catch (e) {
      return const APIResult(success: false, message: "Error occured!");
    }
  }

  /// Update Project
  Future<APIResult> updateProject(Project project) async {
    try {
      return await Apiraiser.data
          .update("Fileheron_Projects", project.id!, project.toJson());
    } catch (e) {
      return const APIResult(success: false, message: "Error occured!");
    }
  }

  //delete Project
  Future<APIResult> deleteProject(String projectID) async {
    try {
      return await Apiraiser.data.delete("Fileheron_Projects", projectID);
    } catch (e) {
      return const APIResult(success: false, message: "Error occured!");
    }
  }
}
