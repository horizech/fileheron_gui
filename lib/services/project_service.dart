import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/models/project.dart';
import 'package:flutter/foundation.dart';

class ProjectDetailService {
  static Future<Project?> getProjectById(int userID) async {
    List<QuerySearchItem> projectConditions = [];

    Project? project;

    projectConditions = [
      QuerySearchItem(
        name: "User",
        condition: ColumnCondition.equal,
        value: userID,
      )
    ];
    try {
      APIResult result =
          await Apiraiser.data.getByConditions("Projects", projectConditions);

      if (result.success &&
          result.data != null &&
          (result.data as List<dynamic>).isNotEmpty) {
        project = (result.data as List<dynamic>)
            .map((k) => Project.fromJson(k as Map<String, dynamic>))
            .first;

        return project;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return null;
  }
}
