// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:apiraiser/apiraiser.dart';
// ignore: implementation_imports
import 'package:apiraiser/src/enums/output_path_prefix.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fileheron_gui/apiraiser/blocs/project.dart';
import 'package:fileheron_gui/apiraiser/models/storage.dart';
import 'package:fileheron_gui/apiraiser/models/project.dart';
import 'package:fileheron_gui/widgets/deployment_loading_widget.dart';
import 'package:fileheron_gui/widgets/fileheron_appbar.dart';
import 'package:fileheron_gui/widgets/fileheron_compact_navdrawer.dart';
import 'package:fileheron_gui/widgets/fileheron_navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_clipboard.dart';
import 'package:flutter_up/widgets/up_alert_dialog.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/services/up_search.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeploymentPage extends StatefulWidget {
  final Function(String)? callback;
  const DeploymentPage({super.key, this.callback});

  @override
  State<DeploymentPage> createState() => _DeploymentPageState();
}

class _DeploymentPageState extends State<DeploymentPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController projectPathController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  List<UpLabelValuePair> projectDropDown = [];
  bool uploadingFile = false;
  bool isZipFile = false;
  bool showURL = false;
  // List<Project> projectList = [];
  List<Project> project = [];
  User? user = Apiraiser.authentication.getCurrentUser();
  String dropDownValue = "";
  String projectName = "projectname";
  String selectedType = '';

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
    FilePickerResult filePickerResult = const FilePickerResult([]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpAlertDialog(
            title: const UpText(
              "Add File",
              type: UpTextType.heading6,
            ),
            content: SizedBox(
              width: 400,
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(12),
                      child: UpText(kIsWeb
                          ? "Files or ZIP File"
                          : "Add Folder or ZIP File")),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        Visibility(
                          visible: !kIsWeb,
                          child: SizedBox(
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
                                      name = result
                                          .split("\\")
                                          .last
                                          .toString()
                                          .toLowerCase();
                                    }
                                  }
                                }),
                          ),
                        ),
                        Visibility(
                          visible: kIsWeb,
                          child: UpButton(
                              colorType: UpColorType.primary,
                              text: "Files",
                              style: UpStyle(
                                  buttonBackgroundColor: UpConfig.of(context)
                                      .theme
                                      .primaryColor
                                      .shade100,
                                  buttonBorderColor: UpConfig.of(context)
                                      .theme
                                      .primaryColor
                                      .shade100,
                                  buttonHoverBackgroundColor:
                                      UpConfig.of(context)
                                          .theme
                                          .primaryColor
                                          .shade200,
                                  buttonHoverBorderColor: UpConfig.of(context)
                                      .theme
                                      .primaryColor
                                      .shade200),
                              onPressed: () async {
                                {
                                  selectedType = "files";
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          withData: true, allowMultiple: true);
                                  filePickerResult = result!;
                                }
                              }),
                        ),
                        UpButton(
                            text: "ZIP File",
                            style: UpStyle(
                                buttonBackgroundColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor
                                    .shade100,
                                buttonBorderColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor
                                    .shade100,
                                buttonHoverBackgroundColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor
                                    .shade200,
                                buttonHoverBorderColor: UpConfig.of(context)
                                    .theme
                                    .primaryColor
                                    .shade200),
                            onPressed: () async {
                              if (kIsWeb) {
                                selectedType = "zip";
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ["zip"],
                                        withData: true,
                                        allowMultiple: false);
                                if (result != null) {
                                  filePickerResult = result;
                                }
                              } else {
                                PlatformFile? file;
                                {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ["zip"],
                                  );
                                  if (result != null) {
                                    file = result.files.first;
                                    if (file.path!.isNotEmpty) {
                                      path = file.path ?? "";
                                      name = file.name.toLowerCase();
                                    }
                                  }
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
            actions: [
              UpButton(
                text: "CONFIRM",
                onPressed: () async {
                  Navigator.pop(context);
                  projectPathController.text = path;
                  if (kIsWeb) {
                    await deployProjectOnWeb(projectID, filePickerResult);
                  } else {
                    await deployProject(
                      projectID,
                      name.toLowerCase(),
                      path,
                    );
                  }
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

  deployProjectOnWeb(String projectID, FilePickerResult result) async {
    String storageID = "";
    Project project;
    bool isDeployed = false;
    APIResult? projectResult =
        await Apiraiser.data.getById("Fileheron_Projects", projectID);
    if (projectResult.success && projectResult.message != "Nothing found!") {
      uploadingFile = true;
      project = (projectResult.data as List<dynamic>)
          .map((k) => Project.fromJson(k as Map<String, dynamic>))
          .first;
      projectName = project.name.toLowerCase();
      isDeployed = project.deployed ?? false;
      _loading();

      //Delete awss folder if already deployed project
      if (isDeployed) {
        APIResult? delDeployedProjectResult =
            await Apiraiser.awss3.deleteByKey(projectName.toLowerCase());
        delDeployedProjectResult.data;
      }
      if (selectedType == "zip") {
        List<PlatformFile> platformFiles = result.files;
        PlatformFile platformFile = platformFiles.first;
        Uint8List fileBytes = platformFile.bytes!;
        APIResult? storageResult = await Apiraiser.storage.upload(
          StorageUploadRequest(
            file: fileBytes,
          ),
        );
        storageID = storageResult?.data;
      } else if (selectedType == "files") {
        Archive archive = Archive();
        for (PlatformFile platformFile in result.files) {
          Uint8List fileBytes = platformFile.bytes!;
          ArchiveFile archiveFile =
              ArchiveFile(platformFile.name, fileBytes.length, fileBytes);
          archive.addFile(archiveFile);
        }
        // Create a zip file from the archive
        List<int>? zipBytes = ZipEncoder().encode(archive);
        // Convert the zip file to a Uint8List
        Uint8List zipUint8List = Uint8List.fromList(zipBytes!);
        APIResult? storageResult = await Apiraiser.storage.upload(
          StorageUploadRequest(
            file: zipUint8List,
          ),
        );
        storageID = storageResult?.data;
      }

      var storage = Storage(projectID: projectID, storageID: storageID);
      await Apiraiser.data
          .insert("Fileheron_Project_Storage", storage.toJson());

      //extract zipfile from storage to temp
      APIResult extractResult = await Apiraiser.archive.extractUsingStorage(
          storageID,
          projectName.toLowerCase(),
          OutputPathPrefix.temporaryDirectory);
      String folderpath = extractResult.data;
      //Upload folder
      APIResult uploadFolderResult = await Apiraiser.awss3
          .uploadFolder(projectName.toLowerCase(), folderpath);
      if (uploadFolderResult.success) {
        project.deployed = true;
        APIResult? projectDeployUpdateResult = await Apiraiser.data
            .update("Fileheron_Projects", projectID, project.toJson());
        projectDeployUpdateResult.data;
      } else {
        UpToast().showToast(context: context, text: "Something went wrong");
      }
      uploadFolderResult.data;

      reloadData();
      setState(() {
        showURL = true;
      });
      Navigator.pop(context);
      uploadingFile = false;
    } else {
      UpToast().showToast(context: context, text: "Project Not Found");
      _deployProjectDialog("");
    }
  }

  deployProject(String projectID, String fileName, String filePath) async {
    String storageID = "";
    Project project;
    bool isDeployed = false;
    checkZipFile(filePath);
    APIResult? projectResult =
        await Apiraiser.data.getById("Fileheron_Projects", projectID);
    if (projectResult.success && projectResult.message != "Nothing found!") {
      uploadingFile = true;
      project = (projectResult.data as List<dynamic>)
          .map((k) => Project.fromJson(k as Map<String, dynamic>))
          .first;
      projectName = project.name.toLowerCase();
      isDeployed = project.deployed ?? false;
      _loading();

      //Delete awss folder if already deployed project
      if (isDeployed) {
        APIResult? delDeployedProjectResult =
            await Apiraiser.awss3.deleteByKey(projectName.toLowerCase());
        delDeployedProjectResult.data;
      }

      //If Folder selected convert to zip
      if (!isZipFile) {
        Directory appDocDirectory = Directory.systemTemp.absolute;
        filePath = "${appDocDirectory.path}\\${projectName.toLowerCase()}.zip";
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

      // //Upload ZipFile to storage
      File file = await File(filePath).create();
      await file.readAsBytes().then((Uint8List list) async {
        APIResult? storageResult = await Apiraiser.storage.upload(
          StorageUploadRequest(
            file: list,
            path: filePath,
            fileName: filePath.split("\\").last.toString(),
          ),
        );
        storageID = storageResult?.data;
      });
      var storage = Storage(projectID: projectID, storageID: storageID);
      await Apiraiser.data
          .insert("Fileheron_Project_Storage", storage.toJson());

      //extract zipfile from storage to temp
      APIResult extractResult = await Apiraiser.archive.extractUsingStorage(
          storageID,
          projectName.toLowerCase(),
          OutputPathPrefix.temporaryDirectory);
      String folderpath = extractResult.data;
      //Upload folder
      APIResult uploadFolderResult = await Apiraiser.awss3
          .uploadFolder(projectName.toLowerCase(), folderpath);
      if (uploadFolderResult.success) {
        project.deployed = true;
        APIResult? projectDeployUpdateResult = await Apiraiser.data
            .update("Fileheron_Projects", projectID, project.toJson());
        projectDeployUpdateResult.data;
      } else {
        UpToast().showToast(context: context, text: "Something went wrong");
      }
      uploadFolderResult.data;

      // APIResult storageDelResult = await Apiraiser.storage.delete(storageID);
      // storageDelResult.message;

      reloadData();
      setState(() {
        showURL = true;
      });
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
    return UpScaffold(
      style: UpStyle(
        scaffoldBodyColor: UpConfig.of(context).theme.baseColor,
        scaffoldFixedDrawerWidthPercentage: 25,
        scaffoldBodyWidthPercentage: 75,
        scaffoldMaximumScreenWidthForCompactDrawer: 700,
      ),
      scaffoldKey: _scaffoldKey,
      fixedDrawer: true,
      appBar: fileHeronAppBar(context, "Deployment"),
      drawer: fileHeronNavDrawer(context),
      compactDrawer: fileHeronCompactNavDrawer(context),
      body: Center(
        child: StreamBuilder(
          stream: projectBloc.stream$,
          builder: (context, AsyncSnapshot<List<Project>?> snapshot) {
            List<Project> documents = snapshot.data ?? [];
            for (var element in documents) {
              dropDownProject.add(UpLabelValuePair(
                  label: element.name, value: "${element.id}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 700,
                child: DeploymentLoadingWidget(),
              );
            } else {
              return StreamBuilder(
                  stream: ServiceManager<UpSearchService>().stream$,
                  builder: (context, searchStream) {
                    return documents.isNotEmpty
                        ? SizedBox(
                            width: 700,
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                        _deployProjectDialog(selectedProjectID);
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Visibility(
                                        visible: showURL,
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
                                                    "https://${projectName.toLowerCase()}.fileheron.com");
                                                UpToast().showToast(
                                                  context: context,
                                                  text: "URL copied!",
                                                  isRounded: true,
                                                );
                                              },
                                              child: Text(
                                                "https://${projectName.toLowerCase()}.fileheron.com",
                                                style: TextStyle(
                                                    color: UpConfig.of(context)
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
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 2 -
                                            50,
                                    bottom:
                                        MediaQuery.of(context).size.height / 2 -
                                            50),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                          );
                  });
            }
          },
        ),
      ),
    );
  }
}
