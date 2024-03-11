import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_gstreamer_player_method_channel.dart';

abstract class FlutterGstreamerPlayerPlatform extends PlatformInterface {
  /// Constructs a FlutterGstreamerPlayerPlatform.
  FlutterGstreamerPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGstreamerPlayerPlatform _instance = MethodChannelFlutterGstreamerPlayer();

  /// The default instance of [FlutterGstreamerPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGstreamerPlayer].
  static FlutterGstreamerPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGstreamerPlayerPlatform] when
  /// they register themselves.
  static set instance(FlutterGstreamerPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
