import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      height: 320.w,
      child: Obx(() {
        return TwoDimensionListView(
          initialPosition: (
            row: iptvController.currentIptv.value.groupIdx,
            col: iptvController.currentIptv.value.idx
          ),
          size: (rowHeight: 300.w, colWidth: 300.w),
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
            RefreshEvent.refreshVod();
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
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.surface, // 设置边框颜色
          width: 3.w, // 设置边框宽度
        ),
        borderRadius: BorderRadius.circular(20).r,
        color: Theme.of(context).colorScheme.surface,
      ),
      // Container的其他属性，例如child、height、width等
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20).r,
                  topRight: Radius.circular(20).r),
            ),
            child: CachedNetworkImage(
              imageUrl: iptv.logo,
              errorWidget: (context,url,value)=>Container(),
            ),
          )),
          Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
              color: isSelected?  Theme.of(context).colorScheme.onSurface:Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(20).r,
                  bottomRight: const Radius.circular(20).r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 10.w,),
                Text(
                  iptv.name,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 30.sp,
                  ),
                  maxLines: 1,
                ),
                Obx(
                  () => Text(
                    iptvController.getIptvProgrammes(iptv).current.value,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.8)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                      fontSize: 24.sp,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
