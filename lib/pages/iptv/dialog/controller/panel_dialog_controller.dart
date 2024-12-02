/*
 * @File     : panel_dialog_controller.dart
 * @Author   : jade
 * @Date     : 2024/10/18 13:43
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';

class PanelDialogController extends GetxController{
  late IptvController  iptvController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    iptvController =  Get.find<IptvController>();
  }

  void close() {
    Get.back();
  }


}