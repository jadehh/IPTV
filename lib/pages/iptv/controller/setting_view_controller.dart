/*
 * @File     : setting_view_controller.dart
 * @Author   : jade
 * @Date     : 2024/10/17 11:04
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:get/get.dart';
import 'package:iptv/common/event/index.dart';
import 'package:iptv/pages/iptv/dialog/controller/panel_dialog_controller.dart';
import 'package:iptv/pages/iptv/view/multi_channel_view.dart';


class SettingItem {
  final String title;
  final void Function() onTap;

  SettingItem({
    required this.title,
    required this.onTap,
  });
}


class SettingViewController extends GetxController{
  late final List<SettingItem> settingItemList;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    settingItemList  = [
      SettingItem(
        title: '节目单',
        onTap: () {
        },
      ),
      SettingItem(
        title: '多线路',
        onTap: ()=>openMultiLinePage(),
      ),
      SettingItem(
        title: '播放控制',
        onTap: (){
        },
      ),
      SettingItem(
        title: '显示设置',
        onTap: (){
        },
      ),
      SettingItem(
        title: '清除缓存',
        onTap: (){
        },
      ),
      SettingItem(
        title: '更多设置',
        onTap: (){
        },
      ),
    ];
  }


  void openMultiLinePage() async{
    RefreshEvent.refresh();
    Get.find<PanelDialogController>().close(); // 关闭选定的对话框
    await Get.dialog(const MultiChannelView());
    RefreshEvent.showIptv();
  }
}