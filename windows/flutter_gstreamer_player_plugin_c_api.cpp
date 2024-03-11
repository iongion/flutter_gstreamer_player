#include "include/flutter_gstreamer_player/flutter_gstreamer_player_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_gstreamer_player_plugin.h"

void FlutterGstreamerPlayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_gstreamer_player::FlutterGstreamerPlayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
