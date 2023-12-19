// import 'dart:math';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/projects_entry_list_tile.dart';
import 'package:flutter/material.dart';

class ProjectsListWidget extends StatelessWidget {
  final List<Project> list;
  final ValueChanged<dynamic> itemClicked;
  final Function onDelete;

  const ProjectsListWidget({
    Key? key,
    required this.list,
    required this.itemClicked,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ProjectsEntryListTileWidget(
                document: list[index],
                itemClicked: itemClicked,
                onDelete: onDelete);
          });
    });
  }
}
