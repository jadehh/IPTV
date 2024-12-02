/*
 * @File     : update_controller.dart
 * @Author   : jade
 * @Date     : 2024/10/10 16:49
 * @Email    : jadehh@1ive.com
 * @Software : Samples
 * @Desc     :
 */
import 'dart:convert';
import 'package:get/get.dart';
import 'package:iptv/common/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



int _compareVersions(String version1, String version2) {
  List<int> v1 = version1.split('.').map(int.parse).toList();
  List<int> v2 = version2.split('.').map(int.parse).toList();

  // 对比主版本号、次版本号和修订号
  for (int i = 0; i < 3; i++) {
    if (v1[i] < v2[i]) {
      return -1;
    } else if (v1[i] > v2[i]) {
      return 1;
    }
  }

  // 如果三个号码都相同，则版本相同
  return 0;
}

final _logger = LoggerUtil.create(['更新']);

class UpdateController extends GetxController  {
  /// 当前版本
  String currentVersion = '0.0.0';

  /// 最新release
  var latestRelease = GithubRelease(tagName: 'v0.0.0', downloadUrl: '', description: '');

  /// 发现更新
  bool get hasUpdate => _compareVersions(latestRelease.tagName.substring(1), currentVersion) > 0;

  /// 正在更新
  bool updating = false;

  /// 获取最新release
  Future<void> refreshLatestRelease() async {
    if (hasUpdate) return;

    try {
      _logger.debug('开始检查更新: ${Constants.githubReleaseLatest}');

      currentVersion = (await PackageInfo.fromPlatform()).version;

      final result = jsonDecode(await RequestUtil.get(Constants.githubReleaseLatest));
      latestRelease = GithubRelease(
        tagName: result['tag_name'],
        downloadUrl: result['assets'][0]['browser_download_url'],
        description: result['body'],
      );

      _logger.debug('检查更新成功: ${latestRelease.tagName}');

      // AppSettings.lastLatestVersion 防止提示频繁
      if (hasUpdate && AppSettings.lastLatestVersion != latestRelease.tagName) {
        showToast('发现新版本: ${latestRelease.tagName}');
        AppSettings.lastLatestVersion = latestRelease.tagName;
      }else{
        _logger.debug("当前版本已是最新版本:${AppSettings.lastLatestVersion}");
      }
    } catch (e, st) {
      _logger.handle(e, st);
      showToast('检查更新失败');
      rethrow;
    }
  }

  /// 下载安装包并安装
  Future<void> downloadAndInstall() async {
    if (!hasUpdate) return;
    if (updating) return;

    updating = true;
    _logger.debug('正在下载更新: ${latestRelease.tagName}');
    showToast('正在下载更新: ${latestRelease.tagName}', duration: const Duration(seconds: 10));
    try {
      final path = await RequestUtil.download(
        url: '${Constants.githubProxy}${latestRelease.downloadUrl}',
        directory: (await getApplicationSupportDirectory()).path,
        name: 'my_tv-latest.apk',
        onProgress: (percent) {
          _logger.debug('正在下载更新: ${percent.toInt()}%');
          showToast('正在下载更新: ${percent.toInt()}%', duration: const Duration(seconds: 10));
        },
      );

      _logger.debug('下载更新成功: $path');
      showToast('下载更新成功');

      if (await Permission.requestInstallPackages.request().isGranted) {
        await ApkInstaller.installApk(path);
      } else {
        showToast('请授予安装权限');
      }
    } catch (e, st) {
      _logger.handle(e, st);
      showToast('下载更新失败');
      rethrow;
    } finally {
      updating = false;
    }
  }
}