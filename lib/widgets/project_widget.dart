import 'dart:io';
import 'dart:typed_data';
import 'package:apiraiser/apiraiser.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/models/storage.dart';
import 'package:fileheron_gui/dialogs/add_edit_site.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
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
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_search.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  List<UpLabelValuePair> projectDropDown = [];
  bool zipingFile = false;
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

  convertToZip(String fileName, String filePath) async {
    String? storageID;
    String projectID;
    checkZipFile(filePath);
    try {
      if (!isZipFile) {
        Directory appDocDirectory = Directory.systemTemp.absolute;
        filePath = "${appDocDirectory.path}\\$fileName.zip";
        var encoder = ZipFileEncoder();
        encoder.create(filePath);
        Directory sourceDir = Directory(projectController.text.toString());
        final List<FileSystemEntity> entities = await sourceDir.list().toList();
        final Iterable<File> sourceFiles = entities.whereType<File>();
        for (var file in sourceFiles) {
          encoder.addFile(file);
        }
        encoder.close();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    File file = await File(filePath).create();
    await file.readAsBytes().then((Uint8List list) async {
      APIResult? result = await Apiraiser.storage.upload(
        StorageUploadRequest(
          file: list,
          path: filePath,
          fileName: filePath.split("\\").last.toString(),
        ),
      );
      storageID = result?.data;
      // ignore: use_build_context_synchronously
      UpToast().showToast(context: context, text: result!.message.toString());
      return null;
    });

    Project project = Project(name: fileName, path: "");
    APIResult? result =
        await Apiraiser.data.insert("Fileheron_Projects", project.toJson());
    // APIResult result =
    //     AddProject().addProject(zipFilePath.split("\\").last, zipFilePath);
    projectID = result.data;
    var storage = Storage(projectID: projectID, storageID: storageID ?? "");
    APIResult? result2 = await Apiraiser.data
        .insert("Fileheron_Project_Storage", storage.toJson());
    reloadData();
    UpToast().showToast(context: context, text: result2.message.toString());
    setState(() {});
  }

  reloadData() {
    projectBloc.getProjects();
  }

  _delete(project, context) async {
    APIResult result = await projectBloc.deleteProject(project.id);
    if (result.success) {
      Navigator.pop(context);
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
        APIResult result = await Apiraiser.data
            .delete("Fileheron_Project_Storage", projectStorage.id ?? "");
        APIResult result2 =
            await Apiraiser.data.delete("Storage", projectStorage.storageID);
        result.data;
        result2.data;
        UpToast().showToast(context: context, text: result2.message.toString());
      }
      reloadData();
      setState(() {});
    } else {}
  }

  _update(Project project, context) async {
    List<QuerySearchItem> conditions = [];
    Storage projectStorage;
    conditions = [
      QuerySearchItem(
          name: "ProjectID",
          condition: ColumnCondition.equal,
          value: project.id)
    ];
    APIResult? result = await Apiraiser.data
        .getByConditions("Fileheron_Project_Storage", conditions);
    if (result.success && result.message != "Nothing found!") {
      projectStorage = (result.data as List<dynamic>)
          .map((k) => Storage.fromJson(k as Map<String, dynamic>))
          .first;
      if (projectStorage.storageID.isNotEmpty) {
        File file = await File(project.path).create();
        await file.readAsBytes().then((Uint8List list) async {
          APIResult? result = await Apiraiser.storage.update(
            projectStorage.storageID,
            StorageUploadRequest(
              file: list,
              path: project.path,
              fileName: "${project.path.split("\\").last}UpDated",
            ),
          );
          UpToast()
              .showToast(context: context, text: result!.message.toString());
          return null;
        });
      }
    } else {
      File file = await File(project.path).create();
      await file.readAsBytes().then((Uint8List list) async {
        APIResult? result = await Apiraiser.storage.upload(
          StorageUploadRequest(
            file: list,
            path: project.path,
            fileName: project.path.split("\\").last.toString(),
          ),
        );

        var storage =
            Storage(projectID: project.id ?? "", storageID: result?.data ?? "");
        if (result!.success) {
          APIResult? result2 = await Apiraiser.data
              .insert("Fileheron_Project_Storage", storage.toJson());
          reloadData();
          UpToast()
              .showToast(context: context, text: result2.message.toString());
          setState(() {});
        } else {}
        return null;
      });
    }
  }

  List<Project> _getFilteredList(List<Project> documents) {
    List<Project> result = [];
    if (documents.isNotEmpty) {
      if (_searchTextEditingController.text.isNotEmpty) {
        String text = _searchTextEditingController.text.toLowerCase();
        result = documents
            .where((x) =>
                x.name.toLowerCase().contains(text) ||
                (x.path).toLowerCase().contains(text))
            .toList();
      } else {
        result = documents.toList();
      }
    }
    return result;
  }

  _addProject() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
            title: const UpText("Add Project"),
            content: Column(
              children: [
                UpTextField(
                  label: "Project Name",
                  controller: projectNameController,
                ),
                UpTextField(
                  label: "Description",
                  controller: projectNameController,
                ),
                const UpText("Add Project Folder or ZIP File"),
                UpButton(
                    text: "ADD Folder",
                    onPressed: () async {
                      {
                        String? result =
                            await FilePicker.platform.getDirectoryPath();
                        if (result != null && result.isNotEmpty) {
                          setState(() {
                            projectController.text = result;
                          });
                        }
                      }
                    }),
                UpButton(
                    text: "ADD ZIP File",
                    onPressed: () async {
                      PlatformFile? file;
                      {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(allowedExtensions: [".zip"]);
                        if (result != null) {
                          file = result.files.first;
                          if (file.path!.isNotEmpty) {
                            projectController.text = file.path ?? "";
                          }
                        }
                      }
                    }),
              ],
            ),
            actions: [
              UpButton(
                text: "CANCEL",
                onPressed: () {},
              ),
              UpButton(
                text: "CONFIRM",
                onPressed: () async {
                  // await checkZipFile(projectNameController.text);
                  await convertToZip(
                    projectNameController.text,
                    projectController.text,
                  );
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

  // Future<File> convertToZip() async {
  //   Directory appDocDirectory = await getExternalStorageDirectory();
  //   var encoder = ZipFileEncoder();
  //   encoder.create(appDocDirectory.path + "/" + 'jay.zip');
  //   encoder.addFile(File(selectedAdharFile));
  //   encoder.addFile(File(selectedIncomeFile));
  //   encoder.close();
  // }
  @override
  Widget build(BuildContext context) {
    reloadData();
    return user?.id != null
        ? StreamBuilder(
            stream: projectBloc.stream$,
            builder: (context, AsyncSnapshot<List<Project>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading"),
                );
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
                            // const Padding(
                            //   padding: EdgeInsets.only(left: 8.0),
                            //   child: UpText("Your Projects: "),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       SizedBox(
                            //         width: 400,
                            //         child: UpDropDown(
                            //           label: 'Projects',
                            //           itemList: projectDropDown,
                            //           value: dropDownValue,
                            //           onChanged: ((value) {
                            //             dropDownValue = value ?? "";
                            //           }),
                            //         ),
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(8),
                            //         ),
                            //         height: 45,
                            //         width: 45,
                            //         child: UpButton(
                            //           onPressed: () async {
                            //             String? result = await FilePicker
                            //                 .platform
                            //                 .getDirectoryPath(
                            //                     // allowMultiple: false,
                            //                     // type: FileType.up,
                            //                     // allowedExtensions: ['jpg', 'pdf', 'doc'],
                            //                     );
                            //             if (result != null &&
                            //                 result.isNotEmpty) {
                            //               setState(() {
                            //                 projectfile = result;
                            //                 projectController.text = result;
                            //               });
                            //             }
                            //           },
                            //           icon: Icons.add,
                            //           style: UpStyle(),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 16),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: UpButton(
                                      style: UpStyle(
                                        buttonBorderRadius: 2,
                                      ),
                                      onPressed: () async {
                                        _addProject();
                                      },
                                      // onPressed: () {
                                      //   convertToZip();
                                      //   setState(() {
                                      //     reloadData();
                                      //   });
                                      // },
                                      text: "Add a new PROJECT"),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: UpText("Your Projects"),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: UpSearch(
                                      style: UpStyle(),
                                      controller: _searchTextEditingController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 600,
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
        : const LoginSignupPage();
  }
}
