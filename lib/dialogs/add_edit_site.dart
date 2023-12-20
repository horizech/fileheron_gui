import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/add_edit_site.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/dialogs/up_base.dart';

class AddEditSiteDialog extends UpBaseDialog {
  @override
  void show(BuildContext context, String completerId, {dynamic data}) {
    // if ((ServiceManager<KeyService>().currentKey)!.isNotEmpty) {
    showDialog(
        context: context,
        builder: (context) => AddEditSiteWidget(
            completerId: completerId, document: data ?? Project.empty()));
    // } else {
    //   Session.endSession(context);
    // }
  }
}
