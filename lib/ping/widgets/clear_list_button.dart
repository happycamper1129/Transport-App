// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/shared_widgets.dart';

class ClearListButton extends StatelessWidget {
  const ClearListButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Constants.getPlatformBtnColor(context),
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 21.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onPressed,
      child: Text('Clear list', style: Theme.of(context).textTheme.button),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(12.0),
      color: Constants.getPlatformBtnColor(context),
      borderRadius: BorderRadius.circular(10.0),
      onPressed: onPressed,
      child: Text('Clear list', style: Theme.of(context).textTheme.button),
    );
  }
}
