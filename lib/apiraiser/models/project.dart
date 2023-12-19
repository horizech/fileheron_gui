import 'package:flutter/material.dart';

class Project {
  String? id;
  DateTime? createdOn;
  String? createdBy;
  DateTime? lastUpdatedOn;
  String? lastUpdatedBy;
  String name;
  String path;

  // final int? media;

  Project({
    required this.name,
    required this.path,
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
  });
  factory Project.empty() {
    Project project = Project(
        id: null, name: "", path: "", createdBy: null, lastUpdatedBy: null);
    return project;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    try {
      Project project = Project(
        id: json['Id'] as String,
        createdOn: json['CreatedOn'] != null
            ? (json['CreatedOn'] is String)
                ? DateTime.parse(json['CreatedOn'] as String)
                : json['CreatedOn']
            : null,
        createdBy: json['CreatedBy'] as String?,
        lastUpdatedOn: json['LastUpdatedOn'] != null
            ? (json['LastUpdatedOn'] is String)
                ? DateTime.parse(json['LastUpdatedOn'] as String)
                : json['LastUpdatedOn']
            : null,
        lastUpdatedBy: json['LastUpdatedBy'] as String?,
        name: json['Name'] as String,
        path: json['Path'] as String,
      );
      // const []);
      return project;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Id'] = id;
    data['Path'] = path;

    return data;
  }
}
