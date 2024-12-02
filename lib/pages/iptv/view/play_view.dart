/*
 * @File     : play_view.dart
 * @Author   : jade
 * @Date     : 2024/10/9 16:34
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

Widget playView(VideoState videoState) {
  return buildWidget(videoState.context.orientation == Orientation.portrait, videoState);
}

Widget buildWidget( bool isPortrait, VideoState videoState,){
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
                child:  const Center(
                  child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,),
                ),
              );
            }
          ),
        ),
  ]);
}
