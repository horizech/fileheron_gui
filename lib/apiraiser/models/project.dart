import 'package:flutter/material.dart';

class Project {
  String? id;
  DateTime? createdOn;
  String? createdBy;
  DateTime? lastUpdatedOn;
  String? lastUpdatedBy;
  String name;
  String? description;
  bool? deployed;

  // final int? media;

  Project({
    required this.name,
    this.description,
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.deployed,
  });
  factory Project.empty() {
    Project project = Project(
        id: null,
        name: "",
        description: "",
        deployed: false,
        createdBy: null,
        lastUpdatedBy: null);
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
        description: json['Description'] as String,
        deployed: json['Deployed'] as bool,
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
    data['Description'] = description;
    data['Deployed'] = deployed;

    return data;
  }
}
