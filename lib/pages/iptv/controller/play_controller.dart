/*
 * @File     : play_controller.dart
 * @Author   : jade
 * @Date     : 2024/10/9 16:34
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

Widget playerControls(VideoState videoState) {
  return buildControls(videoState.context.orientation == Orientation.portrait, videoState);
}

Widget buildControls( bool isPortrait, VideoState videoState,){
  return Stack(
      children: [
        Container(),
        Center(
          child: StreamBuilder(
            stream: videoState.widget.controller.player.stream.buffering,
            initialData: videoState.widget.controller.player.state.buffering,
            builder: (_, s){
              return Visibility(
                visible: s.data ?? false,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          ),
        ),
  ]);
}
