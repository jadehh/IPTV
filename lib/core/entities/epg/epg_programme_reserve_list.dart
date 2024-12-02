/*
 * @File     : epg_programme_reserve_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:00
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 节目预约列表
 */
import 'epg_programme_reserve.dart';

class  EpgProgrammeReserveList{
  ///节目预约列表
  List<EpgProgrammeReserve>? value;
  EpgProgrammeReserveList({List<EpgProgrammeReserve>? value}){
    this.value = value ?? [];
  }
}


