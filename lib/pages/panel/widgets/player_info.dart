import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';

class PanelPlayerInfo extends StatelessWidget {
  const PanelPlayerInfo({super.key});

  static PlayerStore get playerStore => Get.find<PlayerStore>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx( () => Text(
            '分辨率：${playerStore.width.value}×${playerStore.height.value}',
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 30.sp),
          ),
        )
      ],
    );
  }
}
