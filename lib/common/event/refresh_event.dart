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
    EventBus.instance.emit(kRefresh, RefreshType.vod);
  }
}

enum RefreshType {
  //刷新直播
  vod,
}
