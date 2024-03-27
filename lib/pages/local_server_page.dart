import 'package:apiraiser/apiraiser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_gui/widgets/fileheron_appbar.dart';
import 'package:fileheron_gui/widgets/fileheron_navdrawer.dart';
import 'package:fileheron_gui/widgets/fileheron_compact_navdrawer.dart';
import 'package:fileheron_server/fileheron_server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/enums/up_text_direction.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_url.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';

class LocalServerPage extends StatefulWidget {
  final Function(String)? callback;
  const LocalServerPage({super.key, this.callback});

  @override
  State<LocalServerPage> createState() => _LocalServerPageState();
}

class _LocalServerPageState extends State<LocalServerPage> {
  User? user = Apiraiser.authentication.getCurrentUser();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController hostController =
      TextEditingController(text: "localhost");
  TextEditingController portController = TextEditingController(text: "8080");
  TextEditingController rootController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController logFileController = TextEditingController();
  TextEditingController certificateChainController = TextEditingController();
  TextEditingController serverKeyController = TextEditingController();
  bool isListDir = true;
  bool isSsl = false;
  String? rootfile;
  FilePickerResult? logfile;
  FilePickerResult? certificateChain;
  FilePickerResult? serverKey;
  bool isStart = false;
  bool isDisable = false;

  FileHeronServer? server;
  Future<void> _launchUrl(String url) async {
    await ServiceManager<UpUrlService>().openUrl(url);
    // if (!await launchUrl(Uri.parse(url))) {
    //   throw 'Could not launch $url';
    // }
  }

  onStart() {
    ServerParams params = ServerParams(
      hostname:
          hostController.text.isNotEmpty ? hostController.text : kDefaultHost,
      port: portController.text.isNotEmpty
          ? int.parse(portController.text)
          : kDefaultPort,
      listDir: isListDir,
      logFile: logfile != null
          ? logfile!.files.first.path
          : logFileController.text.isNotEmpty
              ? logFileController.text
              : kDefaultLogFile,
      root: rootfile != null && rootfile!.isNotEmpty
          ? rootfile!
          : rootController.text.isNotEmpty
              ? rootController.text
              : kDefaultRoot,
      certificateChain: certificateChain != null
          ? certificateChain!.files.first.path
          : certificateChainController.text.isNotEmpty
              ? certificateChainController.text
              : kDefaultCertificateChain,
      serverKey: serverKey != null
          ? serverKey!.files.first.path
          : serverKeyController.text.isNotEmpty
              ? serverKeyController.text
              : kDefaultServerKey,
      serverKeyPassword: passwordController.text != ""
          ? passwordController.text
          : kDefaultServerKeyPassword,
    );

    server = FileHeronServer();
    server!.initStaticServer(params);
    server!.start();
    setState(() {
      isStart = true;
    });
  }

  onStop() {
    if (server != null) {
      server!.stop();
      setState(() {
        isStart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
        style: UpStyle(
          scaffoldBodyColor: UpConfig.of(context).theme.baseColor,
          scaffoldFixedDrawerWidthPercentage: 25,
          scaffoldBodyWidthPercentage: 75,
          scaffoldMaximumScreenWidthForCompactDrawer: 700,
        ),
        scaffoldKey: _scaffoldKey,
        fixedDrawer: true,
        appBar: fileHeronAppBar(context, "Local Server", _scaffoldKey),
        drawer: fileHeronNavDrawer(context),
        compactDrawer: fileHeronCompactNavDrawer(context),
        body: Container(
          child: kIsWeb
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height / 2) - 100),
                    child: Column(
                      children: [
                        UpText(
                          "Feature not avalible",
                          style: UpStyle(textSize: 22),
                        ),
                        const SizedBox(height: 8),
                        UpText(
                          "Download FileHeron application to access this feature",
                          style: UpStyle(
                              textColor: UpConfig.of(context)
                                  .theme
                                  .baseColor
                                  .shade800),
                        ),
                        const SizedBox(height: 22),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: UpButton(
                              colorType: UpColorType.primary,
                              onPressed: () {},
                              text: "Download",
                              icon: Icons.download,
                            )),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 600,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: UpText("Host: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 60,
                                child: UpTextField(
                                  readOnly: isDisable,
                                  keyboardType: TextInputType.text,
                                  controller: hostController,
                                  style: UpStyle(
                                      textfieldBorderRadius: 8,
                                      textfieldFilledColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade100),
                                  // label: "Host",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: UpText("Port: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 60,
                                child: UpTextField(
                                  readOnly: isDisable,
                                  keyboardType: TextInputType.number,
                                  controller: portController,
                                  style: UpStyle(
                                    textfieldFilledColor: UpConfig.of(context)
                                        .theme
                                        .baseColor
                                        .shade100,
                                    textfieldBorderRadius: 8,
                                  ),
                                  // label: "Valid port",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: UpText("Root: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: styledTextFiled(
                                        rootController, isDisable, context),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    // width: 120,
                                    child: UpButton(
                                        style: UpStyle(
                                          buttonBorderRadius: 8,
                                          isDisabled: isDisable,
                                        ),
                                        onPressed: () async {
                                          String? result = await FilePicker
                                              .platform
                                              .getDirectoryPath(
                                                  // allowMultiple: false,
                                                  // type: FileType.up,
                                                  // allowedExtensions: ['jpg', 'pdf', 'doc'],
                                                  );
                                          if (result != null &&
                                              result.isNotEmpty) {
                                            setState(() {
                                              rootfile = result;
                                              rootController.text = result;
                                            });
                                          }
                                        },
                                        text: "Select"),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  UpCheckbox(
                                      initialValue: isListDir,
                                      style: UpStyle(
                                        checkboxBorderRadius: 2,
                                      ),
                                      label: "Show requests in console?",
                                      labelDirection: UpTextDirection.left,
                                      onChange: (bool? newcheck) {
                                        setState(
                                          () {
                                            isListDir = newcheck ?? false;
                                          },
                                        );
                                      }),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: UpText(" "),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UpCheckbox(
                                label: "Enable SSL?",
                                style: UpStyle(
                                  checkboxBorderRadius: 2,
                                  isDisabled: isDisable,
                                ),
                                labelDirection: UpTextDirection.left,
                                initialValue: isSsl,
                                onChange: (bool? newcheck) {
                                  setState(
                                    () {
                                      isSsl = newcheck ?? false;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isSsl
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: UpText("Log File: "),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: styledTextFiled(
                                                  logFileController,
                                                  isDisable,
                                                  context),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              // width: 120,
                                              child: UpButton(
                                                  style: UpStyle(
                                                      buttonBorderRadius: 8,
                                                      isDisabled: isDisable),
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      allowMultiple: false,
                                                      // type: FileType.up,
                                                      // allowedExtensions: ['jpg', 'pdf', 'doc'],
                                                    );
                                                    if (result != null) {
                                                      setState(() {
                                                        logfile = result;
                                                        logFileController.text =
                                                            logfile!.names
                                                                    .first ??
                                                                "";
                                                      });
                                                    }
                                                  },
                                                  text: "Browse"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                            UpText("Certificate Chain file: "),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: styledTextFiled(
                                                    certificateChainController,
                                                    isDisable,
                                                    context)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              // width: 120,
                                              child: UpButton(
                                                  style: UpStyle(
                                                      buttonBorderRadius: 8,
                                                      isDisabled: isDisable),
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      allowMultiple: false,
                                                    );
                                                    if (result != null) {
                                                      setState(() {
                                                        certificateChain =
                                                            result;
                                                        certificateChainController
                                                                .text =
                                                            certificateChain!
                                                                    .names
                                                                    .first ??
                                                                "";
                                                      });
                                                    }
                                                  },
                                                  text: "Browse"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: UpText("Server Key file: "),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: styledTextFiled(
                                                  serverKeyController,
                                                  isDisable,
                                                  context),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              // width: 120,
                                              child: UpButton(
                                                  style: UpStyle(
                                                      buttonBorderRadius: 8,
                                                      isDisabled: isDisable),
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      allowMultiple: false,
                                                    );
                                                    if (result != null) {
                                                      // File file = File(serverKey!.files.single.path ?? "");
                                                      //  Uint8List fileBytes = serverKey.files.first.bytes;
                                                      setState(() {
                                                        serverKey = result;
                                                        serverKeyController
                                                            .text = serverKey!
                                                                .names.first ??
                                                            "";
                                                      });
                                                    }
                                                  },
                                                  text: "Browse"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: UpText("Server Key Password: "),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 60,
                                          child: UpTextField(
                                            style: UpStyle(
                                              textfieldFilledColor:
                                                  UpConfig.of(context)
                                                      .theme
                                                      .baseColor
                                                      .shade100,
                                              textfieldBorderRadius: 8,
                                            ),
                                            readOnly: isDisable,
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            controller: passwordController,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const UpText(""),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SizedBox(
                                    height: 40,
                                    child: isStart == false
                                        ? SizedBox(
                                            // width: 120,
                                            child: UpButton(
                                              style: UpStyle(
                                                  buttonHeight: 50,
                                                  buttonBorderRadius: 22,
                                                  isDisabled: isDisable),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  onStart();
                                                  setState(() {
                                                    isDisable = true;
                                                  });
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          UpConfig.of(context)
                                                              .theme
                                                              .baseColor
                                                              .shade50,
                                                      title: UpText('Service',
                                                          style: UpStyle(
                                                              textSize: 20,
                                                              textWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      content: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const UpText(
                                                              "Service started at "),
                                                          InkWell(
                                                            onTap: () {
                                                              _launchUrl(
                                                                  "http://${hostController.text}:${portController.text}");
                                                            },
                                                            child: UpText(
                                                              "http://${hostController.text}:${portController.text}",
                                                              style: UpStyle(
                                                                  textDecoration:
                                                                      TextDecoration
                                                                          .underline),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        SizedBox(
                                                          // width: 120,
                                                          child: UpButton(
                                                              style: UpStyle(
                                                                  buttonTextWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              text: 'Ok'),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                              text: 'Start',
                                            ),
                                          )
                                        : SizedBox(
                                            // width: 120,
                                            child: UpButton(
                                              style: UpStyle(
                                                  buttonBorderRadius: 22,
                                                  buttonHeight: 50),
                                              onPressed: () {
                                                onStop();
                                                setState(() {
                                                  isDisable = false;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        UpConfig.of(context)
                                                            .theme
                                                            .baseColor
                                                            .shade50,
                                                    title: UpText('Service',
                                                        style: UpStyle(
                                                          textSize: 20,
                                                        )),
                                                    content: const UpText(
                                                        "Service Stoped"),
                                                    actions: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: UpButton(
                                                            style: UpStyle(
                                                                buttonTextWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            text: 'Ok'),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              text: 'Stop',
                                            ),
                                          )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}

Widget styledTextFiled(
    TextEditingController controller, bool isDisable, context) {
  return SizedBox(
    height: 50,
    child: UpTextField(
      readOnly: isDisable,
      keyboardType: TextInputType.text,
      controller: controller,
      style: UpStyle(
        textfieldFilledColor: UpConfig.of(context).theme.baseColor.shade100,
        textfieldBorderRadius: 8,
      ),
    ),
  );
}
