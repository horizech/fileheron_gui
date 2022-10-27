import 'package:fileheron_gui/widgets/window_buttons.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_server/fileheron_server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_up/enums/up_text_direction.dart';

import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class RightSide extends StatefulWidget {
  const RightSide({Key? key}) : super(key: key);

  @override
  State<RightSide> createState() => _RightSideState();
}

class _RightSideState extends State<RightSide> {
  final _formKey = GlobalKey<FormState>();
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
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
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
      server!.destroy();
      setState(() {
        isStart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange, Colors.yellow],
          stops: [0.0, 0.1],
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.secondary,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [
                    Expanded(
                      child: MoveWindow(),
                    ),
                    const WindowButtons(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Host: "),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 60,
                            child: UpTextField(
                              readOnly: isDisable,
                              keyboardType: TextInputType.text,
                              controller: hostController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              // initialValue: "localhost",
                              // onChanged: (value) => {host = value},
                              label: "host",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Port: "),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 60,
                            child: UpTextField(
                                readOnly: isDisable,
                                keyboardType: TextInputType.number,
                                controller: portController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                // initialValue: "8080",
                                // onChanged: (value) => {port = int.parse(value)},
                                label: "valid port"),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Root: "),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    styledTextFiled(rootController, isDisable),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 40,
                                child: UpButton(
                                    isButtonDisable: isDisable,
                                    isRounded: true,
                                    roundedBorderRadius: 5,
                                    onPress: () async {
                                      String? result = await FilePicker.platform
                                          .getDirectoryPath(
                                              // allowMultiple: false,
                                              // type: FileType.up,
                                              // allowedExtensions: ['jpg', 'pdf', 'doc'],
                                              );
                                      if (result != null && result.isNotEmpty) {
                                        setState(() {
                                          rootfile = result;
                                          rootController.text = result;
                                        });
                                      }
                                    },
                                    child: const Text(" Select ")),
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
                              // const Text("listDir : "),
                              UpCheckbox(
                                  isDisable: isDisable,
                                  activeColor: Theme.of(context).primaryColor,
                                  checkColor:
                                      Theme.of(context).colorScheme.secondary,
                                  isRounded: true,
                                  roundedBorderRadius: 5,
                                  borderWidth: 1.5,
                                  borderColor: Theme.of(context).primaryColor,
                                  initialValue: isListDir,
                                  label: "Show requests in console?",
                                  // lableDirection: TextDirection.ltr,
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
                                child: Text(" "),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UpCheckbox(
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: Theme.of(context).colorScheme.secondary,
                            isRounded: true,
                            roundedBorderRadius: 5,
                            borderWidth: 1.5,
                            borderColor: Theme.of(context).primaryColor,
                            label: "Enable SSL?",
                            labelDirection: UpTextDirection.left,
                            initialValue: isSsl,
                            isDisable: isDisable,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Log File: "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: styledTextFiled(
                                              logFileController, isDisable),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: UpButton(
                                              isButtonDisable: isDisable,
                                              isRounded: true,
                                              roundedBorderRadius: 5,
                                              onPress: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  allowMultiple: false,
                                                  // type: FileType.up,
                                                  // allowedExtensions: ['jpg', 'pdf', 'doc'],
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    logfile = result;
                                                    logFileController.text =
                                                        logfile!.names.first ??
                                                            "";
                                                  });
                                                }
                                              },
                                              child: const Text("Browse")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Certificate Chain file: "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: styledTextFiled(
                                                certificateChainController,
                                                isDisable)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: UpButton(
                                              isButtonDisable: isDisable,
                                              isRounded: true,
                                              roundedBorderRadius: 5,
                                              onPress: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  allowMultiple: false,
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    certificateChain = result;
                                                    certificateChainController
                                                            .text =
                                                        certificateChain!
                                                                .names.first ??
                                                            "";
                                                  });
                                                }
                                              },
                                              child: const Text("Browse")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Server Key file: "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: styledTextFiled(
                                              serverKeyController, isDisable),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: UpButton(
                                              isButtonDisable: isDisable,
                                              isRounded: true,
                                              roundedBorderRadius: 5,
                                              onPress: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  allowMultiple: false,
                                                );
                                                if (result != null) {
                                                  // File file = File(serverKey!.files.single.path ?? "");
                                                  //  Uint8List fileBytes = serverKey.files.first.bytes;
                                                  setState(() {
                                                    serverKey = result;
                                                    serverKeyController.text =
                                                        serverKey!
                                                                .names.first ??
                                                            "";
                                                  });
                                                }
                                              },
                                              child: const Text("Browse")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("Server Key Password: "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 60,
                                      child: UpTextField(
                                        readOnly: isDisable,
                                        keyboardType: TextInputType.text,
                                        obscureText: true,
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.solid,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const Text(""),
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
                                        width: 100,
                                        height: 40,
                                        child: UpButton(
                                          isButtonDisable: isDisable,
                                          isRounded: true,
                                          roundedBorderRadius: 5,
                                          onPress: () {
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
                                                  title: const Text('Service'),
                                                  content: Row(
                                                    children: [
                                                      const Text(
                                                          "Service started at "),
                                                      InkWell(
                                                        onTap: () {
                                                          _launchUrl(
                                                              "http://${hostController.text}:${portController.text}");
                                                        },
                                                        child: Text(
                                                          "http://${hostController.text}:${portController.text}",
                                                          style: const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    UpButton(
                                                        isRounded: true,
                                                        roundedBorderRadius: 5,
                                                        onPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('Ok'))
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Start'),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 100,
                                        height: 40,
                                        child: UpButton(
                                          isRounded: true,
                                          roundedBorderRadius: 5,
                                          onPress: () {
                                            onStop();
                                            setState(() {
                                              isDisable = false;
                                            });
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Service'),
                                                content: const Text(
                                                    "Service Stoped"),
                                                actions: [
                                                  UpButton(
                                                      isRounded: true,
                                                      roundedBorderRadius: 5,
                                                      onPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Ok'))
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Text('Stop'),
                                        ),
                                      )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget styledTextFiled(TextEditingController controller, bool isDisable) {
  return SizedBox(
    height: 50,
    child: UpTextField(
      readOnly: isDisable,
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.solid,
          ),
        ),
      ),
    ),
  );
}
