import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';

class ProjectsEntryListTileWidget extends StatelessWidget {
  final Project document;
  final ValueChanged<dynamic> itemClicked;
  final Function onDelete;

  final int resultsPerpage = 8;

  const ProjectsEntryListTileWidget({
    Key? key,
    required this.document,
    required this.itemClicked,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: UpCard(
        style: UpStyle(
            cardWidth: MediaQuery.of(context).size.width,
            cardBodyPadding: false),
        body: ListTile(
          dense: false,
          isThreeLine: true,
          title: UpText(document.name,
              style: UpStyle(
                  textWeight: UpLayout.isPortrait(context)
                      ? FontWeight.normal
                      : FontWeight.w500)),
          subtitle: UpText(document.description ?? ""),
          leading: SizedBox(
            width: 50,
            child: UpIcon(
              icon: Icons.folder_zip,
              style: UpStyle(iconSize: 40),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: UpIcon(
                  icon: Icons.delete,
                  style: UpStyle(),
                ),
                onPressed: () => onDelete(document),
              ),
              IconButton(
                icon: const UpIcon(
                  icon: Icons.open_in_new,
                ),
                onPressed: () {},
              ),
            ],
          ),
          onTap: () => itemClicked(document),
        ),
      ),
    );
  }
}
