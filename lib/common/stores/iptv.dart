import 'dart:async';
import 'package:iptv/common/index.dart';
import 'package:get/get.dart';



 class IptvStore  {
  /// 直播源分组列表
  List<IptvGroup> iptvGroupList = [];

  /// 直播源列表
  List<Iptv> get iptvList => iptvGroupList.expand((e) => e.list).toList();

  /// 当前直播源
  Iptv currentIptv = Iptv.empty;

  /// 显示iptv信息
  RxBool iptvInfoVisible = false.obs;

  /// 选台频道号
  RxString channelNo = ''.obs;

  /// 确认选台定时器
  Timer? confirmChannelTimer;

  /// 节目单
  List<Epg>? epgList;

  /// 获取上一个直播源
  Iptv getPrevIptv([Iptv? iptv]) {
    final prevIdx = iptvList.indexOf(iptv ?? currentIptv) - 1;
    return prevIdx < 0 ? iptvList.last : iptvList.elementAt(prevIdx);
  }

  /// 获取下一个直播源
  Iptv getNextIptv([Iptv? iptv]) {
    final nextIdx = iptvList.indexOf(iptv ?? currentIptv) + 1;
    return nextIdx >= iptvList.length ? iptvList.first : iptvList.elementAt(nextIdx);
  }

  /// 获取上一个分组直播源
  Iptv getPrevGroupIptv([Iptv? iptv]) {
    final prevIdx = (iptv?.groupIdx.value ?? currentIptv.groupIdx.value) - 1;
    return prevIdx < 0 ? iptvGroupList.last.list.first : iptvGroupList.elementAt(prevIdx).list.first;
  }

  /// 获取下一个分组直播源
  Iptv getNextGroupIptv([Iptv? iptv]) {
    final nextIdx = (iptv?.groupIdx.value ?? currentIptv.groupIdx.value) + 1;
    return nextIdx >= iptvGroupList.length ? iptvGroupList.first.list.first : iptvGroupList.elementAt(nextIdx).list.first;
  }

  /// 刷新直播源列表
  Future<void> refreshIptvList() async {
    iptvGroupList = await IptvUtil.refreshAndGet();
  }

  /// 刷新节目单
  Future<void> refreshEpgList() async {
    epgList = await EpgUtil.refreshAndGet(iptvList.map((e) => e.tvgName).toList());
  }

  /// 手动输入频道号
  void inputChannelNo(String no) {
    confirmChannelTimer?.cancel();

    channelNo.value = channelNo.value + no;
    confirmChannelTimer = Timer(Duration(seconds: 4 - channelNo.value.length), () {
      final channel = int.tryParse(channelNo.value) ?? 0;
      final iptv = iptvList.firstWhere((e) => e.channel.value == channel, orElse: () => currentIptv);
      currentIptv = iptv;
      channelNo = ''.obs;
    });
  }

  // 获取节目单
  ({RxString current, RxString next}) getIptvProgrammes(Iptv iptv) {
    final now = DateTime.now().millisecondsSinceEpoch;

    final epg = epgList?.firstWhereOrNull((element) => element.channel == iptv.tvgName);

    final currentProgramme = epg?.programmes.firstWhereOrNull((element) => element.start <= now && element.stop >= now);
    final nextProgramme = epg?.programmes.firstWhereOrNull((element) => element.start > now);

    return (current: currentProgramme?.title.obs ?? ''.obs, next: nextProgramme?.title.obs ?? ''.obs);
  }

  ({RxString current, RxString next}) get currentIptvProgrammes {
    return getIptvProgrammes(currentIptv);
  }
}
