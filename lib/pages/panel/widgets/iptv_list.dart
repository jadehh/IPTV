import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/event/refresh_event.dart';
import 'package:iptv/common/index.dart';

class PanelIptvList extends StatefulWidget {
  const PanelIptvList({super.key});

  @override
  State<PanelIptvList> createState() => _PanelIptvListState();
}

class _PanelIptvListState extends State<PanelIptvList> {
  static IptvController get iptvController => Get.find<IptvController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: Obx(() {
        return TwoDimensionListView(
          initialPosition: (row: iptvController.currentIptv.value.groupIdx, col: iptvController.currentIptv.value.idx),
          size: (rowHeight: 200.w, colWidth: 260.w),
          scrollOffset: (row: 0, col: -1),
          gap: (row: 20.h, col: 20.w),
          itemCount: (
          row: iptvController.iptvGroupList.length,
          col: (row) => iptvController.iptvGroupList[row].list.length,
          ),
          rowTopBuilder: (context, row) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              iptvController.iptvGroupList[row].name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onSelect: (position) {
            // 选台
            iptvController.currentIptv.value = iptvController.iptvGroupList[position.row].list[position.col];
            RefreshEvent.refresh();
            Navigator.pop(context);
          },
          itemBuilder: (context, position, isSelected) {
            final iptv = iptvController.iptvGroupList[position.row].list[position.col];
            return _buildIptvItem(iptv, isSelected);
          },
        );
      }),
    );
  }

  Widget _buildIptvItem(Iptv iptv, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).r,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            iptv.name,
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
              fontSize: 30.sp,
            ),
            maxLines: 1,
          ),
          Obx( () => Text(
            iptvController.getIptvProgrammes(iptv).current.value,
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.surface.withOpacity(0.8) : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontSize: 24.sp,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
