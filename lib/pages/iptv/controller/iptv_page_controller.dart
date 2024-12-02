/*
 * @File     : iptv_page_controller.dart
 * @Author   : jade
 * @Date     : 2024/10/16 16:27
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:iptv/pages/iptv/dialog/index.dart';
/// 加载状态
enum LoadingState {
  /// 等待中
  loading,

  /// 成功
  success,

  /// 失败
  failed,
}


class IptvPageController extends GetxController{
  final _logger = LoggerUtil.create(['IpTVController']);
  final focusNode = FocusNode();
  PlayController get playController => Get.find<PlayController>();
  IptvController get iptvController => Get.find<IptvController>();
  UpdateController get updateController => Get.find<UpdateController>();
  /// 加载状态
  Rx<LoadingState> loadingState = LoadingState.loading.obs;
  /// 加载信息
  RxString loadingMsg = "".obs;
  /// 加载状态
  RxString loadingProgress = "".obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // 注册监听事件
    EventBus.instance.listen(
      RefreshEvent.kRefresh,
          (index) async {
        switch (index) {
          case RefreshType.vod:
            await refreshPlayer(iptvController.currentIptv.value);
            await iptvController.refreshEpgList();
            break;
          case RefreshType.change:
            await changeIptv();
            break;
          case RefreshType.showIptv:
            Timer(const Duration(milliseconds: 200), () {
              iptvController.iptvInfoVisible.value = true;
            });
            break;
          case RefreshType.hiddenIptv:
            iptvController.iptvInfoVisible.value = false;
            break;
          case RefreshType.hiddenIptvDelay:
            Timer(const Duration(seconds: 2), () {
              iptvController.iptvInfoVisible.value = false;
            });
            break;
        }
      },
    );
    _initData();
  }



  // 刷新播放节目
  Future<void> refreshPlayer(Iptv iptv) async{
    RefreshEvent.showIptv();
    IptvSettings.initialIptvIdx = iptvController.iptvList.indexOf(iptv);
    await playController.playIptv(iptvController.currentIptv.value);
  }


  // 切换源
  Future<void> changeIptv() async{
    String channelIdxStr = IptvSettings.iptvChannelList[iptvController.currentIptv.value.idx];
    int channelIdx = channelIdxStr.isEmpty ? 0 : int.parse(channelIdxStr) ;
    var channelList = IptvSettings.iptvChannelList;
    channelList[iptvController.currentIptv.value.idx] = (channelIdx+1).toString();
    IptvSettings.iptvChannelList = channelList;
    await refreshPlayer(iptvController.currentIptv.value);
  }

  EpgCallBack getEpgCallBack() {
    EpgCallBack callBack = EpgCallBack(retryEpg,"直播源");
    return callBack;
  }

  void retryEpg(String msg){
    loadingProgress.value = msg;
  }

  IPTVCallBack getIPTVCallBack() {
    IPTVCallBack callBack = IPTVCallBack(retryIPTV,"频道源");
    return callBack;
  }

  void retryIPTV(String msg){
    loadingProgress.value = msg;
  }


  Future<void> _initData() async {
    _logger.debug("节目单正在解析");

    try{
      await iptvController.refreshIptvList(callBack: getIPTVCallBack());
    }catch(e){
      loadingState.value = LoadingState.failed;
      loadingMsg.value = "${e.toString()} 获取直播源失败,请检查网络连接";
      return;
    }

    try{
      await iptvController.refreshEpgList(callBack: getEpgCallBack());
    }catch(e){
      loadingState.value = LoadingState.failed;
      loadingMsg.value = "${e.toString()} 获取频道失败,请检查网络连接";
      return;
    }
    iptvController.currentIptv.value = iptvController.iptvList.elementAtOrNull(IptvSettings.initialIptvIdx) ?? iptvController.iptvList.first;
    loadingState.value = LoadingState.success;
    await refreshPlayer(iptvController.currentIptv.value);
    updateController.refreshLatestRelease();
  }

  // 播放下一个节目
  void playNext(){
    iptvController.currentIptv.value = iptvController.getNextIptv();
    RefreshEvent.refreshVod();
  }

  // 播放上一个节目
  void playPrev(){
    iptvController.currentIptv.value = iptvController.getPrevIptv();
    RefreshEvent.refreshVod();
  }

  void openPanelView(BuildContext context) async{
    if(loadingState.value == LoadingState.success){
      RefreshEvent.hiddenIptv();
      await Get.dialog(const PanelDialog());
      RefreshEvent.showIptv();
    }
  }

  void openSettingView(BuildContext context) async {
    if(loadingState.value == LoadingState.success){
      RefreshEvent.hiddenIptv();
      await Get.dialog(const PanelDialog(isSettingView: true,));
      RefreshEvent.showIptv();
    }
  }
}