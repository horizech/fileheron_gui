import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Project extends Equatable {
  final int? id;
  final DateTime? createdOn;
  final int? createdBy;
  final DateTime? lastUpdatedOn;
  final int? lastUpdatedBy;
  final String name;
  final int? user;
  final Map<String, dynamic>? options;
  final Map<String, dynamic>? meta;

  // final int? media;

  const Project({
    this.id,
    this.createdOn,
    this.createdBy,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    required this.name,
    this.user,
    this.options,
    this.meta,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    try {
      Project project = Project(
        id: json['Id'] as int,
        createdOn: json['CreatedOn'] != null
            ? (json['CreatedOn'] is String)
                ? DateTime.parse(json['CreatedOn'] as String)
                : json['CreatedOn']
            : null,
        createdBy: json['CreatedBy'] as int?,
        lastUpdatedOn: json['LastUpdatedOn'] != null
            ? (json['LastUpdatedOn'] is String)
                ? DateTime.parse(json['LastUpdatedOn'] as String)
                : json['LastUpdatedOn']
            : null,
        lastUpdatedBy: json['LastUpdatedBy'] as int?,
        name: json['Name'] as String,
      );
      // const []);
      return project;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  static Map<String, dynamic> toJson(Project instance) {
    Map<String, dynamic> optionsMap = {};
    if (instance.options != null && instance.options!.isNotEmpty) {
      for (var entry in instance.options!.entries) {
        optionsMap[entry.key] = entry.value;
      }
    }
    Map<String, dynamic> metaMap = {};
    if (instance.meta != null && instance.meta!.isNotEmpty) {
      for (var entry in instance.meta!.entries) {
        metaMap[entry.key] = entry.value;
      }
    }

    return <String, dynamic>{
      'Id': instance.id,
      'CreatedOn': instance.createdOn,
      'CreatedBy': instance.createdBy,
      'LastUpdatedOn': instance.lastUpdatedOn,
      'LastUpdatedBy': instance.lastUpdatedBy,
      'Name': instance.name,
      'Options': jsonEncode(optionsMap),
      'Meta': jsonEncode(metaMap),
      'User': instance.user,
    };
  }

  @override
  List<Object?> get props => [
        id,
        createdOn,
        createdBy,
        lastUpdatedOn,
        lastUpdatedBy,
        name,
        user,
      ];
}
