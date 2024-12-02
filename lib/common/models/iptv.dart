/// 直播源
class Iptv {
  /// 序号
  late final int idx;

  /// 频道号
  late final int channel;

  /// 所属分组
  late final int groupIdx;

  /// 名称
  late final String name;

  /// 播放地址
  late final List<String> urlList;

  /// tvg名称
  late final String tvgName;

  /// Logo
  late final String logo;

  Iptv({
    required this.idx,
    required this.channel,
    required this.groupIdx,
    required this.name,
    required this.urlList,
    required this.tvgName,
    required this.logo,
  });

  @override
  String toString() {
    return 'Iptv{idx: $idx, channel: $channel, groupIdx: $groupIdx, name: $name, urlList: $urlList, tvgName: $tvgName},logo:$logo';
  }

  static Iptv get empty => Iptv(idx: 0, channel: 0, groupIdx: 0, name: '', urlList: [], tvgName: '',logo: '');
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
