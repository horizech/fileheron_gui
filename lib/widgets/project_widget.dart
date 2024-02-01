import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/models/storage.dart';
import 'package:fileheron_gui/dialogs/add_edit_site.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
import 'package:fileheron_gui/widgets/project_loading_widget.dart';
import 'package:fileheron_gui/widgets/projects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_console.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/services/up_dialog.dart';
import 'package:flutter_up/services/up_search.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_search.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';

class Projects extends StatefulWidget {
  final Function(String)? callback;
  const Projects({super.key, this.callback});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  TextEditingController projectPathController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  List<UpLabelValuePair> projectDropDown = [];
  bool uploadingFile = false;
  bool isZipFile = false;
  // List<Project> projectList = [];
  List<Project> project = [];
  User? user = Apiraiser.authentication.getCurrentUser();
  String dropDownValue = "";

  checkZipFile(String filePath) {
    List<String> filepath = filePath.split(".");
    for (var i = 0; i < filepath.length; i++) {
      if (filepath[i] == "zip") {
        isZipFile = true;
      }
    }
  }

  _addProject(String projectName, String projectDescription, context) async {
    final regExp = RegExp(r'[\^$*.\[\]{}()?\"!@#%&/\,><:;~`+='
        "'"
        ']');
    if (projectName.length >= 4) {
      if (!projectName.contains(regExp)) {
        Project project = Project(
            name: projectName,
            description: projectDescription,
            deployed: false);
        APIResult? result =
            await Apiraiser.data.insert("Fileheron_Projects", project.toJson());
        if (result.success) {
          UpToast().showToast(context: context, text: "Project added!");
          Navigator.pop(context);
        } else {
          UpToast().showToast(context: context, text: "Something went wrong");
        }
      } else {
        UpToast().showToast(context: context, text: "Improper project name");
      }
    } else {
      UpToast().showToast(
          context: context,
          text: "Project name must contain at least 4 characters");
    }
  }

  reloadData() {
    projectBloc.getProjects();
  }

  _delete(project, context) async {
    APIResult result = await Apiraiser.data
        .delete("Fileheron_Projects", (project.id).toString());
    result.message;
    if (result.success) {
      _loading();
      List<QuerySearchItem> conditions = [];
      Storage projectStorage;
      conditions = [
        QuerySearchItem(
            name: "ProjectID",
            condition: ColumnCondition.equal,
            value: project.id)
      ];
      APIResult? projectStorageResult = await Apiraiser.data
          .getByConditions("Fileheron_Project_Storage", conditions);
       
      reloadData();
      setState(() {});
      Navigator.pop(context);
    } else {}
  }

  List<Project> _getFilteredList(List<Project> documents) {
    List<Project> result = [];
    if (documents.isNotEmpty) {
      if (_searchTextEditingController.text.isNotEmpty) {
        String text = _searchTextEditingController.text.toLowerCase();
        result = documents
            .where((x) =>
                x.name.toLowerCase().contains(text) ||
                (x.description)!.toLowerCase().contains(text))
            .toList();
      } else {
        result = documents.toList();
      }
    }
    return result;
  }

  _loading() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const UpCircularProgress(),
                const SizedBox(height: 8),
                uploadingFile
                    ? const UpText("Uploading Project...")
                    : const UpText("Deleting Project..."),
              ],
            ),
          );
        });
  }

  _addProjectDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
            title: UpText(
              "Add Project",
              style: UpStyle(textSize: 20, textWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 400,
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpTextField(
                    label: "Project Name",
                    controller: projectNameController,
                  ),
                  const SizedBox(height: 12),
                  UpTextField(
                    label: "Description",
                    controller: projectDescriptionController,
                  ),
                ],
              ),
            ),
            actions: [
              UpButton(
                colorType: UpColorType.basic,
                text: "CANCEL",
                style: UpStyle(
                  buttonHoverBackgroundColor:
                      UpConfig.of(context).theme.baseColor.shade400,
                  buttonHoverBorderColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              UpButton(
                text: "CONFIRM",
                style: UpStyle(buttonTextWeight: FontWeight.bold),
                onPressed: () async {
                  // await checkZipFile(projectNameController.text);

                  await _addProject(projectNameController.text,
                      projectDescriptionController.text, context);
                  setState(() {
                    reloadData();
                  });
                },
              ),
            ],
          );
        });
  }

  _openAddUpdateDialog(BuildContext context, Project model) {
    String completerId = ServiceManager<UpDialogService>()
        .showDialog(context, AddEditSiteDialog(), data: model);
    ServiceManager<UpDialogService>()
        .onDialogComplete(completerId)!
        .then((value) {
      if (value != null && value['success'] == true) {
        upConsole(UpConsoleLevel.info, 'Should update');
        reloadData();
      } else {
        upConsole(UpConsoleLevel.info, 'Should not update');
      }
    });
  }

  _openDeleteDialog(BuildContext context, Project model) {
    Widget cancelButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        // width: 100,
        child: UpButton(
          colorType: UpColorType.basic,
          style: UpStyle(
            buttonHoverBackgroundColor:
                UpConfig.of(context).theme.baseColor.shade400,
            buttonHoverBorderColor: Colors.transparent,
          ),
          text: "No",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
    Widget continueButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        // width: 100,
        child: UpButton(
          text: "Yes",
          onPressed: () {
            Navigator.pop(context);
            _delete(model, context);
          },
          style: UpStyle(
              buttonBackgroundColor: UpConfig.of(context).theme.primaryColor),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
      title: const UpText("Delete Project"),
      content: const UpText("Are you sure you want to delete?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            cancelButton,
            continueButton,
          ],
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    reloadData();
    return user?.id != null
        ? StreamBuilder(
            stream: projectBloc.stream$,
            builder: (context, AsyncSnapshot<List<Project>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(width: 500, child: ProjectLodingWidget());
              } else {
                return StreamBuilder(
                    stream: ServiceManager<UpSearchService>().stream$,
                    builder: (context, searchStream) {
                      List<Project> documents = snapshot.data ?? [];
                      List<Project> filteredDocuments =
                          _getFilteredList(documents);
                      return SizedBox(
                        width: 500,
                        child: Form(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(8),
                                  //   color: UpConfig.of(context).theme.baseColor,
                                  // ),
                                  width: 400,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: UpSearch(
                                      controller: _searchTextEditingController,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        color: UpConfig.of(context)
                                            .theme
                                            .primaryColor,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: UpIcon(
                                        icon: Icons.add,
                                        style: UpStyle(
                                            iconColor:
                                                UpThemes.getContrastColor(
                                                    UpConfig.of(context)
                                                        .theme
                                                        .primaryColor)),
                                      ),
                                      onPressed: () async {
                                        _addProjectDialog();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 400,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: ProjectsListWidget(
                                list: filteredDocuments,
                                itemClicked: (doc) =>
                                    _openAddUpdateDialog(context, doc),
                                onDelete: (doc) =>
                                    _openDeleteDialog(context, doc),
                              ),
                            ),
                          ],
                        )),
                      );
                    });
              }
            },
          )
        : LoginSignupPage(callback: widget.callback);
  }
}
