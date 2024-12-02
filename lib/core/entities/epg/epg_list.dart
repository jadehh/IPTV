/*
 * @File     : epg_programme_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:30
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道节目列表
 */
import 'epg.dart';

class EpgList{
  List<Epg>? value;
  EpgList( {List<Epg>?  value}){
    this.value = value ?? [];
  }
}
