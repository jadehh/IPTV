import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';

class PanelIptvInfo extends StatelessWidget {
  final bool epgShowFull;
  const PanelIptvInfo({this.epgShowFull = true, super.key});
  static IptvController get iptvController => Get.find<IptvController>();
  static PlayController get playController => Get.find<PlayController>();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // 频道名称
            Obx(() => Text(
              iptvController.currentIptv.value.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 40.w),
            // 播放状态
            Obx(() => Text(
                playController.state.value == PlayerState.failed ? '播放失败' : '',
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
              '正在播放：${iptvController.currentIptvProgrammes.current.value.isNotEmpty ? iptvController.currentIptvProgrammes.current.value : '无节目'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
              '稍后播放：${iptvController.currentIptvProgrammes.next.value.isNotEmpty ? iptvController.currentIptvProgrammes.next.value : '无节目'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
