import 'dart:io';
import 'package:apiraiser/apiraiser.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fileheron_gui/models/project.dart';
import 'package:fileheron_gui/services/project_service.dart';
import 'package:fileheron_gui/widgets/authentication/loginsignup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_text.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  TextEditingController projectController = TextEditingController();
  String? projectfile;
  List<UpLabelValuePair> projectDropDown = [];
  // List<Project> projectList = [];
  List<Project> project = [];
  User? user = Apiraiser.authentication.getCurrentUser();
  String dropDownValue = "";

  Future<String> convertToZip() async {
    // Directory appDocDirectory = Directory.systemTemp.absolute;
    String zipFilePath =
        "D:\\Programming\\temp1.zip"; //"${appDocDirectory.path}/temp.zip";
    var encoder = ZipFileEncoder();
    encoder.create(zipFilePath);
    Directory sourceDir = Directory(projectController.text.toString());
    final List<FileSystemEntity> entities = await sourceDir.list().toList();
    final Iterable<File> sourceFiles = entities.whereType<File>();
    for (var file in sourceFiles) {
      encoder.addFile(file);
    }
    encoder.close();
    return zipFilePath;
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
    return user?.id != null
        ? FutureBuilder<Project?>(
            future: ProjectDetailService.getProjectById(user?.id ?? 0),
            builder: (BuildContext context, AsyncSnapshot<Project?> snapshot) {
              projectDropDown.add(UpLabelValuePair(
                  label: snapshot.data?.name.toString() ?? "",
                  value: snapshot.data?.id.toString()));
              return SizedBox(
                width: 500,
                child: Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: UpText("Your Projects: "),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 400,
                            child: UpDropDown(
                              label: 'Projects',
                              itemList: projectDropDown,
                              value: dropDownValue,
                              onChanged: ((value) {
                                dropDownValue = value ?? "";
                              }),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 45,
                            width: 45,
                            child: UpButton(
                              onPressed: () async {
                                String? result =
                                    await FilePicker.platform.getDirectoryPath(
                                        // allowMultiple: false,
                                        // type: FileType.up,
                                        // allowedExtensions: ['jpg', 'pdf', 'doc'],
                                        );
                                if (result != null && result.isNotEmpty) {
                                  setState(() {
                                    projectfile = result;
                                    projectController.text = result;
                                  });
                                }
                              },
                              icon: Icons.add,
                              style: UpStyle(),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          child: UpButton(
                              style: UpStyle(
                                buttonBorderRadius: 2,
                              ),
                              onPressed: () {
                                convertToZip();
                              },
                              text: " Deploy "),
                        ),
                      ),
                    ),
                  ],
                )),
              );
            })
        : const LoginSignupPage();
  }
}
