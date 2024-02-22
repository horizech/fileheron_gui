import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shimmer/shimmer.dart';

class DeploymentLoadingWidget extends StatelessWidget {
  const DeploymentLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Shimmer.fromColors(
            baseColor: UpConfig.of(context).theme.baseColor.shade100,
            highlightColor: UpConfig.of(context).theme.baseColor.shade300,
            child: const UpText("Select a project to deploy :"),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: 50,
          width: 700,
          child: Shimmer.fromColors(
            baseColor: UpConfig.of(context).theme.baseColor.shade100,
            highlightColor: UpConfig.of(context).theme.baseColor.shade300,
            child: Container(
              decoration: BoxDecoration(
                  color: UpConfig.of(context).theme.baseColor.shade100,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Center(
        child: SizedBox(
            height: 50,
            width: 120,
            child: Center(
              child: Shimmer.fromColors(
                baseColor: UpConfig.of(context).theme.baseColor.shade100,
                highlightColor: UpConfig.of(context).theme.baseColor.shade300,
                child: Container(
                  decoration: BoxDecoration(
                      color: UpConfig.of(context).theme.baseColor.shade100,
                      borderRadius: BorderRadius.circular(22)),
                ),
              ),
            )),
      ),
      const SizedBox(height: 2),
    ]);
  }
}
