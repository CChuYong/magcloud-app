import 'dart:io';

class DeviceInfoUtil {
  static String getOsAndVersion() {
    return "${Platform.operatingSystem} ${Platform.operatingSystemVersion}";
  }
}
