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
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_console.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/services/up_dialog.dart';
import 'package:flutter_up/services/up_search.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_alert_dialog.dart';
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
    _loading();
    if (project.deployed) {
      APIResult? delDeployedFolderResult =
          await Apiraiser.awss3.deleteByKey(project.name.toLowerCase());
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
      if (projectStorageResult.success &&
          projectStorageResult.message != "Nothing found!") {
        projectStorage = (projectStorageResult.data as List<dynamic>)
            .map((k) => Storage.fromJson(k as Map<String, dynamic>))
            .first;
        APIResult? delStorageResult =
            await Apiraiser.storage.delete(projectStorage.storageID);
        APIResult? delProjectStorageResult = await Apiraiser.data
            .delete("Fileheron_Project_Storage", projectStorage.id ?? "");
        delDeployedFolderResult.data;
        delStorageResult.data;
        delProjectStorageResult.data;
      }
    }
    APIResult result = await Apiraiser.data
        .delete("Fileheron_Projects", (project.id).toString());
    result.message;
    Navigator.pop(context);
    reloadData();
    setState(() {});
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
          return UpAlertDialog(
            title: const UpText(
              "Add Project",
              type: UpTextType.heading6,
            ),
            content: SizedBox(
              width: 380,
              height: 136,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  UpTextField(
                    label: "Project Name",
                    controller: projectNameController,
                  ),
                  const SizedBox(height: 12),
                  UpTextField(
                    label: "Description",
                    controller: projectDescriptionController,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            actions: [
              
              UpButton(
                text: "CONFIRM",
                onPressed: () async {
                  await _addProject(projectNameController.text.toLowerCase(),
                      projectDescriptionController.text, context);
                  setState(() {
                    reloadData();
                  });
                },
              ),
              UpButton(
                colorType: UpColorType.tertiary,
                text: "CANCEL",
                onPressed: () {
                  Navigator.pop(context);
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
          colorType: UpColorType.tertiary,
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
        child: UpButton(
          colorType: UpColorType.warn,
          text: "Yes",
          onPressed: () {
            Navigator.pop(context);
            _delete(model, context);
          },
        ),
      ),
    );

    UpAlertDialog alert = UpAlertDialog(
      title: const UpText(
        "Delete Project",
        type: UpTextType.heading6,
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 16),
        child: SizedBox(
            height: 40,
            width: 380,
            child: UpText("Are you sure you want to delete your project?")),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            continueButton,
            cancelButton,
            
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
                return const SizedBox(width: 700, child: ProjectLodingWidget());
              } else {
                return StreamBuilder(
                    stream: ServiceManager<UpSearchService>().stream$,
                    builder: (context, searchStream) {
                      List<Project> documents = snapshot.data ?? [];
                      List<Project> filteredDocuments =
                          _getFilteredList(documents);
                      return SizedBox(
                        width: 700,
                        child: Form(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 380,
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
                              height: filteredDocuments.length * 100,
                              width: MediaQuery.of(context).size.width,
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
