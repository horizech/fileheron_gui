// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:apiraiser/apiraiser.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/models/storage.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
import 'package:fileheron_gui/widgets/deployment_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_clipboard.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/services/up_search.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';

class Deployment extends StatefulWidget {
  final Function(String)? callback;
  const Deployment({super.key, this.callback});

  @override
  State<Deployment> createState() => _DeploymentState();
}

class _DeploymentState extends State<Deployment> {
  TextEditingController projectPathController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  List<UpLabelValuePair> projectDropDown = [];
  bool uploadingFile = false;
  bool isZipFile = false;
  bool isDeployed = false;
  // List<Project> projectList = [];
  List<Project> project = [];
  User? user = Apiraiser.authentication.getCurrentUser();
  String dropDownValue = "";
  String projectName = "PROJECTNAME";

  checkZipFile(String filePath) {
    List<String> filepath = filePath.split(".");
    for (var i = 0; i < filepath.length; i++) {
      if (filepath[i] == "zip") {
        isZipFile = true;
      }
    }
  }

  reloadData() {
    projectBloc.getProjects();
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

  _deployProjectDialog(String projectID) {
    String path = "";
    String name = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
            title: UpText(
              "Add File",
              style: UpStyle(textSize: 20, textWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 400,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(12),
                      child: UpText("Add Folder or ZIP File")),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: UpButton(
                              text: "Folder",
                              style: UpStyle(buttonBorderRadius: 20),
                              onPressed: () async {
                                {
                                  String? result = await FilePicker.platform
                                      .getDirectoryPath();
                                  if (result != null && result.isNotEmpty) {
                                    path = result;
                                    name = result.split("\\").last.toString();
                                  }
                                }
                              }),
                        ),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: UpButton(
                              text: "ZIP File",
                              style: UpStyle(buttonBorderRadius: 20),
                              onPressed: () async {
                                PlatformFile? file;
                                {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(allowedExtensions: [".zip"]);
                                  if (result != null) {
                                    file = result.files.first;
                                    if (file.path!.isNotEmpty) {
                                      path = file.path ?? "";
                                      name = file.name;
                                    }
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              UpButton(
                text: "CANCEL",
                style: UpStyle(buttonTextWeight: FontWeight.bold),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              UpButton(
                text: "CONFIRM",
                style: UpStyle(buttonTextWeight: FontWeight.bold),
                onPressed: () async {
                  // await checkZipFile(projectNameController.text);
                  Navigator.pop(context);
                  await deployProject(
                    projectID,
                    name,
                    path,
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

  deployProject(String projectID, String fileName, String filePath) async {
    String storageID = "";
    Project project;
    bool isDeployed = false;
    checkZipFile(filePath);
    APIResult? result =
        await Apiraiser.data.getById("Fileheron_Projects", projectID);
    if (result.success && result.message != "Nothing found!") {
      uploadingFile = true;
      project = (result.data as List<dynamic>)
          .map((k) => Project.fromJson(k as Map<String, dynamic>))
          .first;
      projectName = project.name;
      isDeployed = project.deployed ?? false;
      _loading();
      if (!isZipFile) {
        Directory appDocDirectory = Directory.systemTemp.absolute;
        filePath = "${appDocDirectory.path}\\$projectName.zip";
        var encoder = ZipFileEncoder();
        encoder.create(filePath);
        Directory sourceDir = Directory(projectPathController.text.toString());
        final List<FileSystemEntity> entities = await sourceDir.list().toList();
        final Iterable<File> sourceFiles = entities.whereType<File>();
        for (var file in sourceFiles) {
          encoder.addFile(file);
        }
        encoder.close();
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
      });
      var storage = Storage(projectID: projectID, storageID: storageID);
      // if (isDeployed) {
      //   Apiraiser.awss3.deleteByKey(projectName);
      // }
      // await Apiraiser.data
      //     .insert("Fileheron_Project_Storage", storage.toJson());
      // APIResult finalResult =
      //     await Apiraiser.archive.extractUsingStorage(storageID, projectName);
      // APIResult storageDelResult = await Apiraiser.storage.delete(storageID);
      // storageDelResult.message;
      // if (finalResult.success) {
      //   project.deployed = true;
      //   Apiraiser.data
      //       .update("Fileheron_Projects", projectID, project.toJson());
      // }
      // finalResult.data;
      reloadData();
      setState(() {});
      Navigator.pop(context);
      uploadingFile = false;
    } else {
      UpToast().showToast(context: context, text: "Project Not Found");
      _deployProjectDialog("");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<UpLabelValuePair> dropDownProject = [];
    String selectedProjectID = "";
    reloadData();
    return user?.id != null
        ? StreamBuilder(
            stream: projectBloc.stream$,
            builder: (context, AsyncSnapshot<List<Project>?> snapshot) {
              List<Project> documents = snapshot.data ?? [];
              for (var element in documents) {
                dropDownProject.add(UpLabelValuePair(
                    label: element.name, value: "${element.id}"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 500,
                  child: DeploymentLoadingWidget(),
                );
              } else {
                return StreamBuilder(
                    stream: ServiceManager<UpSearchService>().stream$,
                    builder: (context, searchStream) {
                      return documents.isNotEmpty
                          ? SizedBox(
                              width: 500,
                              child: Form(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: UpText(
                                      "Select a project to deploy :",
                                      style: UpStyle(
                                          textColor: UpConfig.of(context)
                                              .theme
                                              .baseColor
                                              .shade800),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: UpDropDown(
                                      style: UpStyle(dropdownBorderRadius: 20),
                                      itemList: dropDownProject,
                                      value: selectedProjectID,
                                      onChanged: (value) {
                                        selectedProjectID = value ?? "";
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                      child: Column(
                                    children: [
                                      UpButton(
                                        text: "DEPLOY",
                                        onPressed: () {
                                          _deployProjectDialog(
                                              selectedProjectID);
                                        },
                                        style: UpStyle(buttonBorderRadius: 22),
                                      ),
                                      const SizedBox(height: 12),
                                      Visibility(
                                          visible: isDeployed,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              UpText(
                                                "Your Project will be deployed at ",
                                                style: UpStyle(
                                                    textColor:
                                                        UpConfig.of(context)
                                                            .theme
                                                            .baseColor
                                                            .shade700),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  upCopyTextToClipboard(
                                                      "https://$projectName.fileheron.com");
                                                  UpToast().showToast(
                                                    context: context,
                                                    text: "URL copied!",
                                                    isRounded: true,
                                                  );
                                                },
                                                child: Text(
                                                  "https://$projectName.fileheron.com",
                                                  style: TextStyle(
                                                      color:
                                                          UpConfig.of(context)
                                                              .theme
                                                              .baseColor
                                                              .shade800,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  )),
                                ],
                              )),
                            )
                          : SizedBox(
                              child: Center(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                    2 -
                                                100),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 8),
                                        UpText(
                                          "First create a project.",
                                          style: UpStyle(
                                              textColor: UpConfig.of(context)
                                                  .theme
                                                  .baseColor
                                                  .shade800,
                                              textSize: 18),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                    });
              }
            },
          )
        : LoginSignupPage(
            callback: widget.callback,
          );
  }
}
