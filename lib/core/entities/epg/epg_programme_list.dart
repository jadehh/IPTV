/*
 * @File     : epg_programme_list.dart
 * @Author   : jade
 * @Date     : 2024/10/18 16:30
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 频道节目列表
 */
import 'epg_programme.dart';

class EpgProgrammeList{
  List<EpgProgramme>? value;
  EpgProgrammeList( {List<EpgProgramme>?  value}){
    this.value = value ?? [];
  }
}
