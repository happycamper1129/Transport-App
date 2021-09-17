// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/models/connectivity_model.dart';
import 'package:network_arch/models/ip_geo_model.dart';
import 'package:network_arch/models/lan_scanner_model.dart';
import 'package:network_arch/models/permissions_model.dart';
import 'package:network_arch/models/ping_model.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/screens/cellular_detail_view.dart';
import 'package:network_arch/screens/dashboard.dart';
import 'package:network_arch/screens/ip_geolocation_view.dart';
import 'package:network_arch/screens/lan_scanner_view.dart';
import 'package:network_arch/screens/permissions_view.dart';
import 'package:network_arch/screens/ping_view.dart';
import 'package:network_arch/screens/wake_on_lan_view.dart';
import 'package:network_arch/screens/wifi_detail_view.dart';
import 'package:network_arch/services/widgets/platform_widget.dart';

void main() {
  // Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PingModel()),
        ChangeNotifierProvider(create: (context) => LanScannerModel()),
        ChangeNotifierProvider(create: (context) => WakeOnLanModel()),
        ChangeNotifierProvider(create: (context) => PermissionsModel()),
        ChangeNotifierProvider(create: (context) => IPGeoModel()),
        Provider(create: (context) => ConnectivityModel()),
      ],
      child: EasyDynamicThemeWidget(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return MaterialApp(
          title: 'Dashboard',
          theme: Constants.themeDataLight,
          darkTheme: Constants.themeDataDark,
          themeMode: EasyDynamicTheme.of(context).themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const Dashboard(),
            '/permissions': (context) => const PermissionsView(),
            '/wifi': (context) => const WiFiDetailView(),
            '/cellular': (context) => const CellularDetailView(),
            '/tools/ping': (context) => const PingView(),
            '/tools/lan': (context) => const LanScannerView(),
            '/tools/wol': (context) => const WakeOnLanView(),
            '/tools/ip_geo': (context) => const IPGeolocationView(),
          },
        );
      },
      iosBuilder: (context) {
        // TODO: Fix iOS specific

        // return CupertinoApp(
        //   title: 'Dashboard',
        //   theme: Constants.cupertinoThemeData,
        //   initialRoute: '/',
        //   routes: {
        //     '/': (context) => const Dashboard(),
        //     '/permissions': (context) => const PermissionsView(),
        //     '/wifi': (context) => const WiFiDetailView(),
        //     '/cellular': (context) => const CellularDetailView(),
        //     '/tools/ping': (context) => const PingView(),
        //     '/tools/lan': (context) => const LanScannerView(),
        //     '/tools/wol': (context) => const WakeOnLanView(),
        //     '/tools/ip_geo': (context) => const IPGeolocationView(),
        //   },
        // );
        return MaterialApp(
          title: 'Dashboard',
          theme: Constants.themeDataLight,
          darkTheme: Constants.themeDataDark,
          themeMode: EasyDynamicTheme.of(context).themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const Dashboard(),
            '/permissions': (context) => const PermissionsView(),
            '/wifi': (context) => const WiFiDetailView(),
            '/cellular': (context) => const CellularDetailView(),
            '/tools/ping': (context) => const PingView(),
            '/tools/lan': (context) => const LanScannerView(),
            '/tools/wol': (context) => const WakeOnLanView(),
            '/tools/ip_geo': (context) => const IPGeolocationView(),
          },
        );
      },
    );
  }
}
