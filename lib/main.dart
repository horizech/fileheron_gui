import 'package:fileheron_gui/constants.dart';
import 'package:fileheron_server/fileheron_server.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileHeron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  FilePickerResult? logfile;
  FilePickerResult? certificateChain;
  FilePickerResult? serverKey;
  bool isStart = false;

  FileHeronServer? server;

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
      root: rootController.text.isNotEmpty ? rootController.text : kDefaultRoot,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("FileHeron Server"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // color: Colors.blue,
              width: 500,
              // height: 1000,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 30.0, left: 15.0, right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Host: "),
                      ),
                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Host';
                              }
                              return null;
                            },
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
                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid port';
                              }
                              return null;
                            },
                          ),
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
                              child: styledTextFiled(rootController),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: () {},
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
                            const Text("listDir : "),
                            Checkbox(
                                activeColor: Colors.black,
                                checkColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: const BorderSide(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                value: isListDir,
                                onChanged: (bool? newcheck) {
                                  setState(
                                    () {
                                      isListDir = newcheck ?? false;
                                    },
                                  );
                                }),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text("SSl : "),
                            ),
                            Checkbox(
                                activeColor: Colors.black,
                                checkColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: const BorderSide(
                                  width: 1.5,
                                  color: Colors.black,
                                ),
                                value: isSsl,
                                onChanged: (bool? newcheck) {
                                  setState(
                                    () {
                                      isSsl = newcheck ?? false;
                                    },
                                  );
                                }),
                          ],
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
                                        child:
                                            styledTextFiled(logFileController),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                allowMultiple: false,
                                                // type: FileType.custom,
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
                                  child: Text("CertificateChain file: "),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: styledTextFiled(
                                              certificateChainController)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                allowMultiple: false,
                                              );
                                              if (result != null) {
                                                setState(() {
                                                  certificateChain = result;
                                                  certificateChainController
                                                      .text = certificateChain!
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
                                  child: Text("ServerKey file: "),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: styledTextFiled(
                                            serverKeyController),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: ElevatedButton(
                                            onPressed: () async {
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
                                                      serverKey!.names.first ??
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
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
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
                                  ? ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          onStart();
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Service'),
                                              content: Text(
                                                  "Service started at http://${hostController.text}:${portController.text}"),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ok'))
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Start'),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        onStop();
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Service'),
                                            content:
                                                const Text("Service Stoped"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ok'))
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text('Stop'),
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget styledTextFiled(TextEditingController controller) {
  return SizedBox(
    height: 50,
    child: TextFormField(
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
