import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:shimmer/shimmer.dart';

class ProjectLodingWidget extends StatelessWidget {
  const ProjectLodingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 380,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Shimmer.fromColors(
                baseColor: UpConfig.of(context).theme.baseColor.shade100,
                highlightColor: UpConfig.of(context).theme.baseColor.shade300,
                child: Container(
                  decoration: BoxDecoration(
                      color: UpConfig.of(context).theme.baseColor.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  height: 50,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Shimmer.fromColors(
              baseColor: UpConfig.of(context).theme.baseColor.shade100,
              highlightColor: UpConfig.of(context).theme.baseColor.shade300,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: UpConfig.of(context).theme.baseColor.shade100,
                    shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Shimmer.fromColors(
            baseColor: UpConfig.of(context).theme.baseColor.shade100,
            highlightColor: UpConfig.of(context).theme.baseColor.shade300,
            child: Container(
              decoration: BoxDecoration(
                  color: UpConfig.of(context).theme.baseColor.shade100,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 2),
      Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Shimmer.fromColors(
            baseColor: UpConfig.of(context).theme.baseColor.shade100,
            highlightColor: UpConfig.of(context).theme.baseColor.shade300,
            child: Container(
              decoration: BoxDecoration(
                  color: UpConfig.of(context).theme.baseColor.shade100,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 2),
      Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Shimmer.fromColors(
            baseColor: UpConfig.of(context).theme.baseColor.shade100,
            highlightColor: UpConfig.of(context).theme.baseColor.shade300,
            child: Container(
              decoration: BoxDecoration(
                  color: UpConfig.of(context).theme.baseColor.shade100,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ),
    ]);
  }
}
