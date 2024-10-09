import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:iptv/common/index.dart';


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

 class PlayerStore  {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);
  /// 宽高比
  double? aspectRatio;

  /// 分辨率
  RxInt width = 0.obs;

  RxInt height = 0.obs;


  /// 播放状态
  Rx<PlayerState> state = PlayerState.waiting.obs;

  Future<void> init() async {
    player.stream.error.listen((event){
      print(event);
      // state.value = PlayerState.failed;
      // player.stop();
    });

    player.stream.height.listen((data) {
      if(data!=null){
        height.value = data;
      }
    });

    player.stream.width.listen((data){
      if(data!=null){
        width.value = data;
      }
    });
    // await controller.create();
  }

  /// 播放直播源
  Future<void> playIptv(Iptv iptv) async {
    try {
      _logger.debug('播放直播源: $iptv');
      state.value = PlayerState.waiting;
      await player.open(Media(iptv.url));
    } catch (e, st) {
      _logger.handle(e, st);
      state.value = PlayerState.failed;
      rethrow;
    }
  }
}
