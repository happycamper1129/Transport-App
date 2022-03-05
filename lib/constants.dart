// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/introduction/introduction.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

// ignore_for_file: avoid-global-state

abstract class Constants {
  static const String appName = 'NetworkArch';
  static const String appDesc = '''
      NetworkArch is a network diagnostic tool equipped with various utilities, 
      including pinging specific IP address or hostname, sending Wake on LAN magic packets,
      whois and DNS Lookup.''';

  static const String usageDesc = 'We never share this data with anyone.';

  static const String overviewBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () => Navigator.of(context).pop(),
        ),
    '/wifi': (context) => const WifiDetailedView(),
    '/carrier': (context) => const CarrierDetailView(),
    '/tools/ping': (context) => const PingView(),
    '/tools/lan': (context) => const LanScannerView(),
    '/tools/wol': (context) => const WakeOnLanView(),
    '/tools/ip_geo': (context) => const IpGeoView(),
    '/tools/whois': (context) => const WhoisView(),
    '/tools/dns_lookup': (context) => const DnsLookupView(),
  };

  // Styles
  static const EdgeInsets listPadding = EdgeInsets.all(10.0);

  static const EdgeInsets bodyPadding = EdgeInsets.all(10.0);

  static const double listSpacing = 10.0;

  static const double linearProgressWidth = 50.0;

  static const Divider listDivider = Divider(
    height: 2,
    indent: 12,
    endIndent: 0,
  );

  // Colors
  static const Color iOSlightBgColor = CupertinoColors.systemGrey5;
  static const Color iOSdarkBgColor = CupertinoColors.black;
  static final Color lightBgColor = Colors.grey[100]!;
  static final Color darkBgColor = Colors.grey[900]!;

  static const CupertinoDynamicColor iOSCardColor = CupertinoColors.systemGrey5;
  static final Color lightCardColor = Colors.grey[200]!;
  static final Color darkCardColor = Colors.grey[850]!;
  // static final Color iOSdarkCardColor = CupertinoColors.systemGrey5.darkColor;

  static const CupertinoDynamicColor iOSBtnColor = CupertinoColors.systemGrey4;
  static final Color lightBtnColor = Colors.grey[300]!;
  static final Color darkBtnColor = Colors.grey[800]!;
  // static final Color iOSdarkBtnColor = CupertinoColors.systemGrey4.darkColor;

  static Color getPlatformBgColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return isDarkModeOn
        ? Platform.isAndroid
            ? Constants.darkBgColor
            : Constants.iOSdarkBgColor
        : Platform.isAndroid
            ? Constants.lightBgColor
            : Constants.iOSlightBgColor;
  }

  static Color getPlatformCardColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Platform.isIOS
        ? Constants.iOSCardColor.resolveFrom(context)
        : isDarkModeOn
            ? Constants.darkCardColor
            : Constants.lightCardColor;
  }

  static Color getPlatformBtnColor(BuildContext context) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return Platform.isIOS
        ? Constants.iOSBtnColor.resolveFrom(context)
        : isDarkModeOn
            ? Constants.darkBtnColor
            : Constants.lightBtnColor;
  }

  // Description styles
  static final TextStyle descStyleLight = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle descStyleDark = TextStyle(
    color: Colors.grey[400],
  );

  // Tools descriptions
  static const String pingDesc =
      'Send ICMP pings to specific IP address or domain';

  static const String lanScannerDesc =
      'Discover network devices in local network';

  static const String wolDesc = 'Send magic packets on your local network';

  static const String ipGeoDesc =
      'Get the geolocation of a specific IP address';

  static const String whoisDesc = 'Look up information about a specific domain';

  static const String dnsDesc = 'Get the DNS records of a specific domain';

  // Error descriptions
  static const String defaultError = "Couldn't read the data";

  static const String simError = 'No SIM card';

  static const String noReplyError = 'No reply received from the host';

  static const String unknownError = 'Unknown error';

  static const String unknownHostError = 'Unknown host';

  static const String requestTimedOutError = 'Request timed out';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'We need your location permission in order to access Wi-Fi information';

  static const String phoneStatePermissionDesc =
      'We need your phone permission in order to access carrier information';

  // Permissions snackbars
  static const String _permissionGranted = 'Permission granted.';

  static const String _permissionDenied =
      '''Permission denied, the app may not function properly, check the app's settings.''';

  static const String _permissionDefault =
      'Something gone wrong, check app permissions.';

  static void showPermissionGrantedNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    isDarkModeOn
        ? _permissionGrantedNotificationDark.show(context)
        : _permissionGrantedNotification.show(context);
  }

  static final ElegantNotification _permissionGrantedNotification =
      ElegantNotification.success(
    title: const Text('Success'),
    description: const Text(_permissionGranted),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  static final ElegantNotification _permissionGrantedNotificationDark =
      ElegantNotification.success(
    title: const Text('Success'),
    description: const Text(_permissionGranted),
    background: Constants.darkCardColor,
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  // -----------------------------------------------

  static void showPermissionDeniedNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    isDarkModeOn
        ? _permissionDeniedNotificationDark.show(context)
        : _permissionDeniedNotification.show(context);
  }

  static final ElegantNotification _permissionDeniedNotification =
      ElegantNotification.error(
    title: const Text('Error'),
    description: const Text(_permissionDenied),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
    height: 140.0,
    action: const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Open Settings',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
    onActionPressed: () {
      openAppSettings();
    },
  );

  static final ElegantNotification _permissionDeniedNotificationDark =
      ElegantNotification.error(
    title: const Text('Error'),
    description: const Text(_permissionDenied),
    background: Constants.darkCardColor,
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
    height: 140.0,
    action: const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Open Settings',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
    onActionPressed: () {
      openAppSettings();
    },
  );

  // -----------------------------------------------

  static void showPermissionDefaultNotification(
    BuildContext context,
  ) {
    final bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    isDarkModeOn
        ? _permissionDefaultNotificationDark.show(context)
        : _permissionDefaultNotification.show(context);
  }

  static final ElegantNotification _permissionDefaultNotification =
      ElegantNotification.error(
    title: const Text('Warning'),
    description: const Text(_permissionDefault),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  static final ElegantNotification _permissionDefaultNotificationDark =
      ElegantNotification.error(
    title: const Text('Warning'),
    description: const Text(_permissionDefault),
    background: Constants.darkCardColor,
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
  );

  // -----------------------------------------------

  // Wake On Lan snackbars
  static const String _wolValidationError =
      '''The IP address or MAC address is not valid, please check it and try again.''';

  static final ElegantNotification wolValidationErrorNotification =
      ElegantNotification.error(
    title: const Text('Validation error'),
    description: const Text(_wolValidationError),
    notificationPosition: NOTIFICATION_POSITION.bottom,
    animation: ANIMATION.fromBottom,
    toastDuration: const Duration(milliseconds: 4000),
  );
}
