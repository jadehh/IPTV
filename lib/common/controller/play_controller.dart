/*
 * @File     : play_view.dart
 * @Author   : jade
 * @Date     : 2024/10/10 14:05
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */

import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// 播放状态
enum PlayerState {
  /// 等待播放
  waiting,
  /// 播放中
  playing,
  /// 播放失败
  failed,
}

final _logger = LoggerUtil.create(['播放器']);


class PlayController extends GetxController {
  static IptvController get iptvController => Get.find<IptvController>();

  // 视频播放控制器
  final Player player = Player(configuration: const PlayerConfiguration(logLevel: MPVLogLevel.error));

  //视频控制器
  late final VideoController controller = VideoController(player);

  // 视频宽度
  RxInt width = 0.obs;

  // 视频高度
  RxInt height = 0.obs;

  /// 播放状态
  Rx<PlayerState> state = PlayerState.waiting.obs;


  // 播放信息

  RxString msg = "".obs;


  // 初始化
  @override
  void onInit() async {
    super.onInit();

    player.stream.buffering.listen((event){
      if(event && state.value == PlayerState.waiting){
        state.value = PlayerState.playing;
        _logger.debug("正在解析播放连接中");
      }
      if(event == false && state.value != PlayerState.waiting){
        if(state.value != PlayerState.failed){
          RefreshEvent.hiddenDelayIptv();
          _logger.debug("播放成功");
        }else{
          RefreshEvent.showIptv();
          if(iptvController.currentChannel.value + 1 < iptvController.currentIptv.value.urlList.length){
            RefreshEvent.changeIptv();
          }
          // 自动切换下一个源
          _logger.debug("播放失败");
        }
      }
    });


    // player.stream.playing.listen((event) {
    //   _logger.debug("Playing:$event");
    //   // if (event && state.value == PlayerState.loading){
    //   //   _logger.debug("正在打开播放连接");
    //   //   state.value = PlayerState.waiting;
    //   // }
    //   // if (state.value != PlayerState.loading ){
    //   //   if(event){
    //   //     _logger.debug("播放连接打开成功");
    //   //     state.value = PlayerState.playing;
    //   //   }else{
    //   //     _logger.debug("播放连接打开失败");
    //   //     state.value = PlayerState.failed;
    //   //   }
    //   // }
    // });

    player.stream.error.listen((event) {
      _logger.debug("Error:$event");
      // 显示失败原因
      msg.value  = event;
      state.value = PlayerState.failed;
      player.stop();
    });

    player.stream.log.listen((log) {
      _logger.debug("Log:$log");
    });


    player.stream.height.listen((data) {
      if (data != null) {
        height.value = data;
      } else {
        height.value = 0;
      }
    });

    player.stream.width.listen((data) {
      if (data != null) {
        width.value = data;
      } else {
        width.value = 0;
      }
    });
  }


  // 播放直播源
  Future<void> playIptv(Iptv iptv) async {
    try {
      //如果是多源,优先获取上次的线路
      var channelList = IptvSettings.iptvChannelList;
      var initialChannelIdx = channelList[iptv.idx].isEmpty ? 0 : int.parse(IptvSettings.iptvChannelList[iptv.idx]);
      iptvController.currentChannel.value = initialChannelIdx;
      channelList[iptv.idx] = initialChannelIdx.toString();
      IptvSettings.iptvChannelList = channelList;
      state.value = PlayerState.waiting;
      _logger.debug('播放直播源: ${iptv.urlList.elementAt(initialChannelIdx)},源idx:$initialChannelIdx');
      player.open(Media(iptv.urlList.elementAt(initialChannelIdx)));
      // await player.open(Media(iptv.url));
    } catch (e, st) {
      _logger.handle(e, st);
      state.value = PlayerState.failed;
      rethrow;
    }
  }
}
