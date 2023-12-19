import 'package:flutter/material.dart';

class Storage {
  String? id;
  DateTime? createdOn;
  String? createdBy;
  DateTime? lastUpdatedOn;
  String? lastUpdatedBy;
  String projectID;
  String storageID;

  // final int? media;

  Storage({
    required this.projectID,
    required this.storageID,
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
  });
  factory Storage.empty() {
    Storage project = Storage(
        id: null,
        projectID: "",
        storageID: "",
        createdBy: null,
        lastUpdatedBy: null);
    return project;
  }

  factory Storage.fromJson(Map<String, dynamic> json) {
    try {
      Storage project = Storage(
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
        projectID: json['ProjectID'] as String,
        storageID: json['StorageID'] as String,
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
    data['ProjectID'] = projectID;
    data['Id'] = id;
    data['StorageID'] = storageID;

    return data;
  }
}
