import 'package:get/get.dart';

/// 直播源
class Iptv {
  /// 序号
  late final RxInt idx;

  /// 频道号
  late final RxInt channel;

  /// 所属分组
  late final RxInt groupIdx;

  /// 名称
  late final RxString name;

  /// 播放地址
  late final String url;

  /// tvg名称
  late final String tvgName;

  Iptv({
    required this.idx,
    required this.channel,
    required this.groupIdx,
    required this.name,
    required this.url,
    required this.tvgName,
  });

  @override
  String toString() {
    return 'Iptv{idx: $idx, channel: $channel, groupIdx: $groupIdx, name: $name, url: $url, tvgName: $tvgName}';
  }

  static Iptv get empty => Iptv(idx: 0.obs, channel: 0.obs, groupIdx: 0.obs, name: ''.obs, url: '', tvgName: '');
}

/// 直播源分组
class IptvGroup {
  /// 序号
  late final int idx;

  /// 名称
  late final String name;

  /// 直播源列表
  late final List<Iptv> list;

  IptvGroup({required this.idx, required this.name, required this.list});

  @override
  String toString() {
    return 'IptvGroup{idx: $idx, name: $name, list: ${list.length}}';
  }

  static IptvGroup get empty => IptvGroup(idx: 0, name: '', list: []);
}
