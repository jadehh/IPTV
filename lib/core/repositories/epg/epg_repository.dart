/*
 * @File     : epg_repository.dart
 * @Author   : jade
 * @Date     : 2024/10/18 17:17
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     : 节目单获取
 */


import 'package:iptv/common/enums/iptv_setting.dart';
import 'package:iptv/common/utils/logger.dart';
import 'package:iptv/core/entities/epg/epg_list.dart';
import 'package:iptv/core/entities/epgsource/epg_source.dart';
final _logger = LoggerUtil.create(['epg']);
class EpgRepository{
  EpgSource source;
  EpgRepository(this.source);

  // 获取节目单列表
  EpgList getEpgList(){
    final now = DateTime.now();
    if (now.hour < IptvSettings.epgRefreshTimeThreshold) {
      _logger.debug('未到时间点，不刷新epg');
      return EpgList();
    }else{
      return EpgList();
    }
  }

}
