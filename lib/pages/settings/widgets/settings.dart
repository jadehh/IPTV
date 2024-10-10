import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'logger.dart';

class SettingGroup {
  final String name;
  final List<SettingItem> items;

  SettingGroup({required this.name, required this.items});
}

class SettingItem {
  final String title;
  final String Function() value;
  final String Function() description;
  final void Function() onTap;
  final void Function()? onLongTap;

  SettingItem({
    required this.title,
    required this.value,
    required this.description,
    required this.onTap,
    this.onLongTap,
  });
}

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  static IptvController get iptvController => Get.find<IptvController>();
  static UpdateController get updateController => Get.find<UpdateController>();


  late final List<SettingItem> _settingItemList;

  String _formatDuration(int ms) {
    if (ms < 60000) {
      return '${ms ~/ 1000}秒';
    } else if (ms < 3600000) {
      return '${ms ~/ 60000}分钟';
    } else {
      return '${ms ~/ 3600000}小时';
    }
  }

  void _showServerQrcode() {
    NavigatorUtil.push(
      context,
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(20).r,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 200.h,
              width: 200.h,
              child: PrettyQrView.data(
                data: HttpServerUtil.serverUrl,
                decoration: PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshSettingGroupList();

    HttpServerUtil.init().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.w + 20.h,
      child: TwoDimensionListView(
        size: (rowHeight: 190.w, colWidth: 400.w),
        scrollOffset: (row: 0, col: -1),
        gap: (row: 20.h, col: 20.w),
        itemCount: (
          row: 1,
          col: (_) => _settingItemList.length,
        ),
        onSelect: (position) => setState(() {
          _settingItemList.elementAtOrNull(position.col)?.onTap();
        }),
        onLongSelect: (position) => setState(() {
          _settingItemList.elementAtOrNull(position.col)?.onLongTap?.call();
        }),
        itemBuilder: (context, position, isSelected) {
          final item = _settingItemList[position.col];

          return _buildSettingItem(item, isSelected);
        },
      ),
    );
  }

  Widget _buildSettingItem(SettingItem item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(30).r,
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 30.sp,
                ),
              ),
              Text(
                item.value(),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),
          Text(
            item.description(),
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
              fontSize: 24.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  void refreshSettingGroupList() {
    final groupList = [
      SettingGroup(name: '应用', items: [
        SettingItem(
          title: '应用更新',
          value: () => updateController.hasUpdate ? '新版本' : '无更新',
          description: () => '最新版本：${updateController.latestRelease.tagName} ${updateController.hasUpdate ? '（长按更新）' : ''}',
          onTap: () {
            if (updateController.hasUpdate) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(updateController.latestRelease.tagName),
                  content: SingleChildScrollView(
                    child: Text(updateController.latestRelease.description),
                  ),
                ),
              );
            }
          },
          onLongTap: () {
            updateController.downloadAndInstall();
          },
        ),
        SettingItem(
          title: '开机自启',
          value: () => AppSettings.bootLaunch ? '启用' : '禁用',
          description: () => '下次重启生效',
          onTap: () {
            AppSettings.bootLaunch = !AppSettings.bootLaunch;
          },
        ),
      ]),
      SettingGroup(name: '控制', items: [
        SettingItem(
          title: '换台反转',
          value: () => IptvSettings.channelChangeFlip ? '反转' : '正常',
          description: () => IptvSettings.channelChangeFlip ? '方向键上：下一个频道\n方向键下：上一个频道' : '方向键上：上一个频道\n方向键下：下一个频道',
          onTap: () {
            IptvSettings.channelChangeFlip = !IptvSettings.channelChangeFlip;
          },
        ),
      ]),
      SettingGroup(name: '直播源', items: [
        SettingItem(
          title: '直播源精简',
          value: () => IptvSettings.iptvSourceSimplify ? '启用' : '禁用',
          description: () => IptvSettings.iptvSourceSimplify ? '显示精简直播源(仅央视、地方卫视)' : '显示完整直播源',
          onTap: () {
            IptvSettings.iptvSourceSimplify = !IptvSettings.iptvSourceSimplify;
            IptvSettings.epgCacheHash = 0;
            iptvController.refreshIptvList().then((_) => setState(() {}));
          },
        ),
        SettingItem(
          title: '自定义直播源',
          value: () => IptvSettings.customIptvSource.isNotEmpty ? '已启用' : '未启用',
          description: () => IptvSettings.customIptvSource.isNotEmpty ? '长按恢复默认' : '点击查看网址二维码',
          onTap: () => _showServerQrcode(),
          onLongTap: () {
            IptvSettings.customIptvSource = '';
            IptvSettings.iptvSourceCacheTime = 0;
            iptvController.refreshIptvList().then((_) => setState(() {}));
          },
        ),
        SettingItem(
          title: '直播源缓存',
          value: () => _formatDuration(IptvSettings.iptvSourceCacheKeepTime),
          description: () => IptvSettings.iptvSourceCacheTime > 0 ? "已缓存(点击清除缓存)" : "未缓存",
          onTap: () {
            if (IptvSettings.iptvSourceCacheTime > 0) {
              IptvSettings.iptvSourceCacheTime = 0;
              iptvController.refreshIptvList().then((_) => setState(() {}));
            }
          },
        ),
      ]),
      SettingGroup(name: '节目单', items: [
        SettingItem(
          title: '节目单',
          value: () => IptvSettings.epgEnable ? '启用' : '禁用',
          description: () => '首次加载时可能会有跳帧风险',
          onTap: () {
            IptvSettings.epgEnable = !IptvSettings.epgEnable;
            iptvController.refreshEpgList().then((_) => setState(() {}));
          },
        ),
        SettingItem(
          title: '自定义节目单',
          value: () => IptvSettings.customEpgXml.isNotEmpty ? '已启用' : '未启用',
          description: () => IptvSettings.customEpgXml.isNotEmpty ? '长按恢复默认' : '点击查看网址二维码',
          onTap: () => _showServerQrcode(),
          onLongTap: () {
            IptvSettings.customEpgXml = '';
            IptvSettings.epgXmlCacheTime = 0;
            IptvSettings.epgCacheHash = 0;
            iptvController.refreshEpgList().then((_) => setState(() {}));
          },
        ),
        SettingItem(
          title: '节目单缓存',
          value: () => '当天',
          description: () => IptvSettings.epgXmlCacheTime > 0 ? "已缓存(点击清除缓存)" : "未缓存",
          onTap: () {
            if (IptvSettings.epgXmlCacheTime > 0) {
              IptvSettings.epgXmlCacheTime = 0;
              IptvSettings.epgCacheHash = 0;
              iptvController.refreshEpgList().then((_) => setState(() {}));
            }
          },
        ),
      ]),
      SettingGroup(name: '调试', items: [
        SettingItem(
          title: '显示FPS',
          value: () => ShowFPS.isShowing ? '启用' : '禁用',
          description: () => '显示当前帧率',
          onTap: () {
            ShowFPS.toggle(context);
          },
        ),
        SettingItem(
          title: '延时渲染',
          value: () => DebugSettings.delayRender ? '启用' : '禁用',
          description: () => '对各个组件延时渲染，减少卡顿掉帧',
          onTap: () {
            DebugSettings.delayRender = !DebugSettings.delayRender;
          },
        ),
        SettingItem(
          title: '日志',
          value: () => '${LoggerUtil.history.length}条',
          description: () => '点击查看日志',
          onTap: () {
            if (LoggerUtil.history.isNotEmpty) {
              NavigatorUtil.push(context, SettingsLogger());
            } else {
              showToast('无日志记录');
            }
          },
        ),
      ]),
      SettingGroup(name: '更多', items: [
        SettingItem(
          title: '更多设置',
          value: () => '',
          description: () => '访问以下网址进行配置：${HttpServerUtil.serverUrl}',
          onTap: () => _showServerQrcode(),
        ),
      ]),
    ];

    _settingItemList = groupList.expand((element) => element.items).toList();
  }
}
