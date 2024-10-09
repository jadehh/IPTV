import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';

class PanelIptvInfo extends StatelessWidget {
  PanelIptvInfo({this.epgShowFull = true, super.key});

  late final bool epgShowFull;
  static IptvStore get iptvStore => Get.find<IptvStore>();
  static PlayerStore get playerStore => Get.find<PlayerStore>();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // 频道名称
            Obx(() => Text(
                iptvStore.currentIptv.name.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 40.w),
            // 播放状态
            Obx(() => Text(
                playerStore.state == PlayerState.failed ? '播放失败' : '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        // 节目单
        Obx( () => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: epgShowFull ? 1.sw : 500.w),
            child: Text(
              '正在播放：${iptvStore.currentIptvProgrammes.current.value.isNotEmpty ? iptvStore.currentIptvProgrammes.current.value : '无节目'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                fontSize: 30.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Obx( () => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: epgShowFull ? 1.sw : 500.w),
            child: Text(
              '稍后播放：${iptvStore.currentIptvProgrammes.next.value.isNotEmpty ? iptvStore.currentIptvProgrammes.next.value : '无节目'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                fontSize: 30.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
