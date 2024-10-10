/*
 * @File     : play_controller.dart
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
  // static IptvController get iptvController => Get.find<IptvController>();

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
    player.stream.playing.listen((event) {
      _logger.debug("Playing:$event");
    });

    player.stream.error.listen((event) {
      _logger.debug("Error:$event");
      player.stop();
      state.value = PlayerState.failed;
      // 显示失败原因
      msg.value  = event;
      // // 一致显示节目单
      // iptvController.iptvInfoVisible.value = true;
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
      _logger.debug('播放直播源: $iptv');
      state.value = PlayerState.waiting;
      player.open(Media(iptv.url));
      // await player.open(Media(iptv.url));
    } catch (e, st) {
      _logger.handle(e, st);
      state.value = PlayerState.failed;
      rethrow;
    }
  }
}
