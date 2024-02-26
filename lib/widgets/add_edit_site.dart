// ignore_for_file: use_build_context_synchronously

import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/helpers/up_clipboard.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/widgets/up_alert_dialog.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:flutter_up/services/up_dialog.dart';

class AddEditSiteWidget extends StatefulWidget {
  final Project document;
  final String completerId;
  const AddEditSiteWidget(
      {Key? key, required this.completerId, required this.document})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEditSiteWidgetState createState() => _AddEditSiteWidgetState();
}

class _AddEditSiteWidgetState extends State<AddEditSiteWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  bool isProjectLoading = false;
  _AddEditSiteWidgetState();

  @override
  void initState() {
    super.initState();

    _nameTextEditingController.text = widget.document.name;
    _descriptionTextEditingController.text = widget.document.description ?? "";
  }

  _saveSite() async {
    if (_formKey.currentState!.validate()) {
      Project project = Project(
        name: _nameTextEditingController.text,
        description: _descriptionTextEditingController.text,
        deployed: false,
      );
      APIResult result;

      if (widget.document.id != null && widget.document.id!.isNotEmpty) {
        project.id = widget.document.id!;
        result = await projectBloc.updateProject(project);
      } else {
        result = await projectBloc.insertProject(project);
      }

      if (result.success) {
        UpToast().showToast(
          context: context,
          text: "Saved successfully!",
          isRounded: true,
        );
        ServiceManager<UpDialogService>().completeDialog(
            context: context,
            completerId: widget.completerId,
            result: {'success': true});
      } else {
        UpToast().showToast(
          context: context,
          isRounded: true,
          text: result.message ?? "Could not save!",
        );
        ServiceManager<UpDialogService>().completeDialog(
            context: context,
            completerId: widget.completerId,
            result: {'success': false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpAlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UpText(
          widget.document.id != null && widget.document.id!.isNotEmpty
              ? "Update site"
              : "Add Site",
          type: UpTextType.heading6,
        ),
      ),
      content: SizedBox(
        width: UpLayout.isLandscape(context)
            ? MediaQuery.of(context).size.width * 0.3
            : MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    UpTextField(
                      readOnly: false,
                      isFlexible: true,
                      label: 'Name',
                      controller: _nameTextEditingController,
                    ),
                    IconButton(
                      icon: const UpIcon(icon: Icons.content_copy),
                      onPressed: () {
                        upCopyTextToClipboard(_nameTextEditingController.text);
                        UpToast().showToast(
                          context: context,
                          text: "Name copied!",
                          isRounded: true,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    UpTextField(
                      readOnly: false,
                      isFlexible: true,
                      label: 'Description',
                      controller: _descriptionTextEditingController,
                    ),
                    IconButton(
                      icon: const UpIcon(icon: Icons.content_copy),
                      onPressed: () {
                        upCopyTextToClipboard(
                            _descriptionTextEditingController.text);
                        UpToast().showToast(
                          context: context,
                          text: "Description copied!",
                          isRounded: true,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        SizedBox(
          // width: 100,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: UpButton(
              text: "UPDATE",
              onPressed: () {
                _saveSite();
              },
            ),
          ),
        ),
        SizedBox(
          // width: 100,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: UpButton(
              colorType: UpColorType.tertiary,
              text: "CANCEL",
              style: UpStyle(
                buttonHoverBackgroundColor:
                    UpConfig.of(context).theme.baseColor.shade400,
                buttonHoverBorderColor: Colors.transparent,
              ),
              onPressed: () => ServiceManager<UpDialogService>().completeDialog(
                  context: context,
                  completerId: widget.completerId,
                  result: {'success': false}),
            ),
          ),
        ),
      ],
    );
  }
}
