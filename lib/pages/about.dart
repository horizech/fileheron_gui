import 'package:apiraiser/apiraiser.dart';
import 'package:fileheron_gui/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/helpers/up_layout.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: UpAppBar(
        titleWidget: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.home);
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/file-heron-128.png"),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const SizedBox(
              child: UpText(
                "FileHeron",
                type: UpTextType.heading6,
              ),
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: Apiraiser.authentication.getCurrentUser() == null,
            child: UpButton(
              colorType: UpColorType.tertiary,
              onPressed: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.home);
              },
              text: "Sign in",
            ),
          ),
          const SizedBox(width: 16),
          Visibility(
            visible: !UpLayout.isPortrait(context) &&
                Apiraiser.authentication.getCurrentUser() == null,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: UpButton(
                colorType: UpColorType.primary,
                onPressed: () {
                  ServiceManager<UpNavigationService>()
                      .navigateToNamed(Routes.home);
                },
                text: "Create an account",
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpCard(
                  style: UpStyle(cardBodyPadding: true),
                  body: Wrap(
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    direction: MediaQuery.of(context).size.width > 1200
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.4 - 40
                              : MediaQuery.of(context).size.width - 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width > 1200
                                            ? 160
                                            : 20),
                                child: UpText("Secure, smart, and easy to use",
                                    type: UpTextType.heading3,
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ),
                              const SizedBox(height: 22),
                              UpText(
                                "Effortlessly deploy your projects with our user-friendly platform, simplifying the process in just a few steps.",
                                type: UpTextType.heading6,
                                style: UpStyle(
                                    textColor: UpConfig.of(context)
                                        .theme
                                        .baseColor
                                        .shade800),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        // width: 500,
                        width: MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.6 - 40
                            : MediaQuery.of(context).size.width - 16,
                        height: 600,
                        child: Image.asset(
                          "assets/homeweb_design.png",
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpCard(
                  style: UpStyle(cardBodyPadding: true),
                  body: Wrap(
                    runAlignment: WrapAlignment.spaceAround,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    direction: MediaQuery.of(context).size.width > 1200
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      SizedBox(
                        // width: 500,
                        width: MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.45 - 40
                            : MediaQuery.of(context).size.width - 16,
                        height: 500,
                        child: Image.asset(
                          "assets/add_project.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.45 - 40
                              : MediaQuery.of(context).size.width - 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width > 1200
                                            ? 150
                                            : 20),
                                child: UpText("1. Add a project",
                                    type: UpTextType.heading3,
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: UpText(
                                  "Initiate your project journey by seamlessly adding a new project - simply input a Name and Description to get started.",
                                  type: UpTextType.heading6,
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpCard(
                  style: UpStyle(cardBodyPadding: true),
                  body: Wrap(
                    runAlignment: WrapAlignment.spaceAround,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    direction: MediaQuery.of(context).size.width > 1200
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.45 - 40
                              : MediaQuery.of(context).size.width - 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width > 1200
                                            ? 150
                                            : 20),
                                child: UpText("2. Select Project to Deploy",
                                    type: UpTextType.heading3,
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: UpText(
                                  "Proceed to the deploy page and effortlessly select your project for a smooth deployment process.",
                                  type: UpTextType.heading6,
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        // width: 500,
                        width: MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.45 - 40
                            : MediaQuery.of(context).size.width - 16,
                        height: 500,
                        child: Image.asset(
                          "assets/deploy_project.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpCard(
                  style: UpStyle(cardBodyPadding: true),
                  body: Wrap(
                    runAlignment: WrapAlignment.spaceAround,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    direction: MediaQuery.of(context).size.width > 1200
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      SizedBox(
                        // width: 500,
                        width: MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.45 - 40
                            : MediaQuery.of(context).size.width - 16,
                        height: 500,
                        child: Image.asset(
                          "assets/select_file.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.45 - 40
                              : MediaQuery.of(context).size.width - 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width > 1200
                                            ? 150
                                            : 20),
                                child: UpText("3. Select ZIP file or folder",
                                    type: UpTextType.heading3,
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: UpText(
                                  "Complete the process by choosing the zip file or folder you wish to deploy - the final step in ensuring a hassle-free deployment experience.",
                                  type: UpTextType.heading6,
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UpCard(
                  style: UpStyle(cardBodyPadding: true),
                  body: Wrap(
                    runAlignment: WrapAlignment.spaceAround,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    direction: MediaQuery.of(context).size.width > 1200
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.45 - 40
                              : MediaQuery.of(context).size.width - 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width > 1200
                                            ? 150
                                            : 20),
                                child: UpText("Local Server",
                                    type: UpTextType.heading3,
                                    style: UpStyle(
                                        textColor: UpConfig.of(context)
                                            .theme
                                            .baseColor
                                            .shade800)),
                              ),
                              const SizedBox(height: 22),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: UpText(
                                  "Explore the added flexibility of deploying your project on a local server directly through your PC, offering a convenient and efficient deployment option.",
                                  type: UpTextType.heading6,
                                  style: UpStyle(
                                      textColor: UpConfig.of(context)
                                          .theme
                                          .baseColor
                                          .shade800),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        // width: 500,
                        width: MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.45 - 40
                            : MediaQuery.of(context).size.width - 16,
                        height: 500,
                        child: Image.asset(
                          "assets/local_server.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
