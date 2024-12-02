/*
 * @Author: jadehh
 * @Date: 2024-08-19 11:18:32
 * @LastEditTime: 2024-08-21 17:25:46
 * @LastEditors: jadehh
 * @Description: 
 * @FilePath: \drama_source\drama_source_core\lib\src\event\refresh_event.dart
 * 
 */


import 'event.dart';

class RefreshEvent {
  static String kRefresh = "refresh";


  static void refresh() {
    EventBus.instance.emit(kRefresh, RefreshType.refresh);
  }
  static void refreshVod() {
    EventBus.instance.emit(kRefresh, RefreshType.vod);
  }

  static void changeIptv() {
    EventBus.instance.emit(kRefresh, RefreshType.change);
  }

  static void showIptv() {
    EventBus.instance.emit(kRefresh, RefreshType.showIptv);
  }

  static void hiddenIptv() {
    EventBus.instance.emit(kRefresh, RefreshType.hiddenIptv);
  }

  static void hiddenDelayIptv() {
    EventBus.instance.emit(kRefresh, RefreshType.hiddenIptvDelay);
  }

}

enum RefreshType {
  //刷新布局
  refresh,

  //刷新直播
  vod,

  //切换源
  change,

  //刷新节目单
  showIptv,

  //隐藏节目单
  hiddenIptv,

  //延迟隐藏节目单
  hiddenIptvDelay

}
